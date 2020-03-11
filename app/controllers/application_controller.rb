class ApplicationController < ActionController::API
  protected

  def current_user
    @current_user ||= auth_token ? User.find_by!(auth0_id: auth_token.first["sub"]) : nil
  end

  def current_ability
    Ability.new(current_user)
  end

  def http_token
    auth_header = request.headers["authorization"]&.split(" ")
    auth_header&.first == "Bearer" ? auth_header.last : nil
  end

  def auth_token
    http_token ? JsonWebToken.verify(http_token) : nil
  rescue JWT::VerificationError, JWT::DecodeError
    nil
  end
end
