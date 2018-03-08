Bracket.all.map(&:user).uniq.each do |user|
  begin
    auth0_id = Auth0Api.lookup(user.email) || Auth0Api.create_user(user.email)
  rescue ::Auth0::BadRequest
    auth0_id = nil
  rescue Auth0::Unsupported
    sleep 5
    retry
  end

  user.update!(auth0_id: auth0_id) if auth0_id
end
