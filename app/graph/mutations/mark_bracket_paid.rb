module Mutations
  MARK_BRACKET_PAID_LAMBDA = lambda do |_object, inputs, context|
    user = context[:current_user]

    raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

    bracket = Bracket.find(inputs["bracketId"])

    raise GraphQL::ExecutionError, "You cannot mark this bracket paid" unless bracket.pool.admins.include?(user)

    bracket.paid!
    bracket.update(payment_collector: user)

    if bracket.valid?
      { bracket: bracket }
    else
      { errors: bracket.errors.messages }
    end
  end

  MarkBracketPaid = GraphQL::Relay::Mutation.define do
    name "MarkBracketPaid"
    description "Allows a pool admin to mark a bracket as paid"

    input_field :bracketId, !types.ID

    return_field :bracket, Types::BracketType
    return_field :errors, ValidationErrorList

    resolve MARK_BRACKET_PAID_LAMBDA
  end
end
