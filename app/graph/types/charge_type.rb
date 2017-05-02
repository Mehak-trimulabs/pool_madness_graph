module Types
  ChargeType = GraphQL::ObjectType.define do
    name "Charge"
    description "A stripe credit card charge"

    field :stripeId, !types.ID, property: :id
    field :amount, !types.Int # in cents
    field :description, types.String
  end
end
