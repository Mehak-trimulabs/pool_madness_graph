module Types
  CurrentUserType = GraphQL::ObjectType.define do
    name "CurrentUser"
    description "Current user's details"

    field :email, !types.String
    field :name, !types.String
    field :admin, !types.Boolean, property: :admin?
  end
end
