module Mutations
  RootMutation = GraphQL::ObjectType.define do
    name "RootMutation"
    description "The mutation root of this schema"

    field :createCharge, field: CreateCharge.field
    field :acceptInvitation, field: AcceptInvitation.field
    field :updateProfile, field: UpdateProfile.field
    field :createBracket, field: CreateBracket.field
    field :updateBracket, field: UpdateBracket.field
    field :deleteBracket, field: DeleteBracket.field
  end
end
