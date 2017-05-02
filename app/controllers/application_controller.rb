class ApplicationController < ActionController::API
  include Knock::Authenticable

  protected

  def current_user
    sub = auth_token.payload["sub"]
    email = auth_token.payload["email"]

    current_user = nil

    if sub
      begin
        current_user = User.find_by(auth0_id: sub)

        unless current_user
          # legacy user?
          current_user = User.find_by(email: email, auth0_id: nil)
          current_user.try(:update!, auth0_id: sub)
        end

        current_user ||= User.create!(auth0_id: sub, email: email)
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
        retry
      end

      begin
        current_user.update!(email: email) if email.present? && email != current_user.email
      rescue ActiveRecord::StaleObjectError
        current_user.reload
        retry
      end
    end

    current_user
  end

  def current_ability
    Ability.new(current_user)
  end

  def auth_token
    Knock::AuthToken.new(token: token)
  end
end
