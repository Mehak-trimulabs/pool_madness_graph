module Mutations
  UPDATE_BRACKET_LAMBDA = lambda do |_object, inputs, context|
    user = context[:current_user]
    ability = context[:current_ability]

    raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

    bracket = Bracket.find(inputs["bracketId"])

    raise GraphQL::ExecutionError, "You cannot update this bracket" unless ability.can?(:edit, bracket)

    game_decisions = inputs["gameDecisions"] ? ::BitstringUtils.to_int(inputs["gameDecisions"]) : bracket.game_decisions
    game_mask = inputs["gameMask"] ? ::BitstringUtils.to_int(inputs["gameMask"]) : bracket.game_mask
    bracket.update(
      {
        name: inputs["name"],
        tie_breaker: inputs["tieBreaker"],
        tree_decisions: game_decisions,
        tree_mask: game_mask
      }.compact
    )

    if bracket.valid?
      { bracket: bracket }
    else
      { errors: bracket.errors.messages }
    end
  end

  UpdateBracket = GraphQL::Relay::Mutation.define do
    name "UpdateBracket"
    description "Update a bracket entry"

    input_field :bracketId, !types.ID
    input_field :name, types.String
    input_field :tieBreaker, types.Int
    input_field :gameDecisions, types.String
    input_field :gameMask, types.String

    return_field :bracket, Types::BracketType
    return_field :errors, ValidationErrorList

    resolve UPDATE_BRACKET_LAMBDA
  end
end
