module Mutations
  CREATE_BRACKET_LAMBDA = lambda { |_object, inputs, context|
    user = context[:current_user]
    ability = context[:current_ability]

    raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

    pool = GraphqlSchema.object_from_id(inputs["poolId"], {})

    raise GraphQL::ExecutionError, "You cannot create a bracket in this pool" unless ability.can?(:create, pool.brackets.build(user: user))

    bracket = pool.brackets.create(
      {
        user: user,
        name: inputs["name"],
        tie_breaker: inputs["tieBreaker"],
        tree_decisions: ::BitstringUtils.to_int(inputs["gameDecisions"]),
        tree_mask: ::BitstringUtils.to_int(inputs["gameMask"])
      }.compact
    )

    connection_class = GraphQL::Relay::BaseConnection.connection_for_nodes(pool.brackets.accessible_by(ability))
    connection = connection_class.new(pool.brackets.accessible_by(ability), {})

    if bracket.valid?
      { bracketEdge: GraphQL::Relay::Edge.new(bracket, connection), pool: pool }
    else
      { errors: bracket.errors.messages, pool: pool }
    end
  }

  CreateBracket = GraphQL::Relay::Mutation.define do
    name "CreateBracket"

    input_field :poolId, !types.ID
    input_field :name, !types.String
    input_field :tieBreaker, !types.Int
    input_field :gameDecisions, !types.String
    input_field :gameMask, !types.String

    return_field :bracketEdge, Types::BracketType.edge_type
    return_field :pool, Types::PoolType
    return_field :errors, ValidationErrorList

    resolve CREATE_BRACKET_LAMBDA
  end
end
