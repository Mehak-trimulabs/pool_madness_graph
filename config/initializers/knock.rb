Knock.setup do |config|
  config.token_audience = -> { ENV["AUTH0_CLIENT_ID"] }
  config.token_signature_algorithm = "RS256"
  config.token_secret_signature_key = -> { ENV["AUTH0_CLIENT_SECRET"] }

  # config.token_public_key = nil

  unless Rails.env.test?
    jwks_raw = Net::HTTP.get URI("https://#{ENV['AUTH0_DOMAIN']}/.well-known/jwks.json")
    jwks_keys = Array(JSON.parse(jwks_raw)["keys"])

    config.token_public_key = OpenSSL::X509::Certificate.new(Base64.decode64(jwks_keys[0]["x5c"].first)).public_key
  end
end
