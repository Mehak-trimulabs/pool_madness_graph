module Types
  UserType = GraphQL::ObjectType.define do
    name "User"
    description "User's details"

    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id

    field :name, !types.String
  end
end
