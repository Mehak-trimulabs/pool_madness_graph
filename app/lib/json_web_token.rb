require "net/http"
require "uri"

class JsonWebToken
  AUDIENCE = ENV["AUTH0_CLIENT_ID"]
  ISSUER = "https://#{ENV['AUTH0_DOMAIN']}/".freeze

  def self.verify(token)
    JWT.decode(token, nil,
               true, # Verify the signature of this token
               algorithm: "RS256",
               iss: ISSUER,
               verify_iss: true,
               aud: AUDIENCE,
               verify_aud: true) do |header|
      jwks_hash[header["kid"]]
    end
  end

  def self.jwks_hash
    jwks_raw = Net::HTTP.get URI("#{ISSUER}.well-known/jwks.json")
    jwks_keys = Array(JSON.parse(jwks_raw)["keys"])
    Hash[
        jwks_keys
        .map do |k|
          [
            k["kid"],
            OpenSSL::X509::Certificate.new(
              Base64.decode64(k["x5c"].first)
            ).public_key
          ]
        end
    ]
  end
end
