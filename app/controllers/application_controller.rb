class ApplicationController < ActionController::API
  include Knock::Authenticable

  protected

  def current_user
    @current_user ||= auth_token ? User.find_by!(auth0_id: auth_token.payload["sub"]) : nil
  end

  def current_ability
    Ability.new(current_user)
  end

  def auth_token
    @auth_token ||= Knock::AuthToken.new(token: token) if token.present?
  end
end
