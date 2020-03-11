class Auth0Api
  class << self
    # return auth0_id of created user
    def create_user(email)
      res = client.create_user(email, connection: "email", email: email, email_verified: true)
      res["user_id"]
    end

    def lookup(email)
      res = client.users_by_email(email).first
      res["user_id"] if res
    end

    def lookup_email(auth0_id)
      res = client.user(auth0_id)
      res["email"]
    end

    private

    def client
      Auth0::Client.new(
        client_id: ENV["AUTH0_MGMT_CLIENT_ID"],
        token: ENV["AUTH0_MGMT_TOKEN"],
        domain: ENV["AUTH0_DOMAIN"],
        api_version: 2
      )
    end
  end
end
