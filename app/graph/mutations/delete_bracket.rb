module Mutations
  DELETE_BRACKET_LAMBDA = lambda do |_object, inputs, context|
    user = context[:current_user]
    ability = context[:current_ability]

    raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

    bracket = Bracket.find(inputs["bracketId"])
    pool = bracket.pool

    if ability.can?(:destroy, bracket)
      bracket.destroy
    else
      raise GraphQL::ExecutionError, "You cannot delete this bracket"
    end

    {
      deletedBracketId: inputs["bracketId"],
      pool: pool
    }
  end

  DeleteBracket = GraphQL::Relay::Mutation.define do
    name "DeleteBracket"

    input_field :bracketId, !types.ID

    return_field :deletedBracketId, !types.ID
    return_field :pool, Types::PoolType

    resolve DELETE_BRACKET_LAMBDA
  end
end
