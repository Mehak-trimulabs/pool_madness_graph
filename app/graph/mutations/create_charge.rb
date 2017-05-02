module Mutations
  CREATE_CHARGE_LAMBDA = lambda { |_object, inputs, context|
    pool = GraphqlSchema.object_from_id(inputs["poolId"], context)

    raise ActiveRecord::RecordNotFound unless context[:current_ability].can?(:read, pool)

    user = context[:current_user]
    brackets = pool.brackets.where(user_id: user.id).to_a.select { |b| b.status == :unpaid }
    amount = brackets.size * pool.entry_fee

    charge = Stripe::Charge.create(
      amount: amount,
      currency: "usd",
      source: inputs["token"],
      description: "#{brackets.size} bracket(s) in the pool #{pool.name} at PoolMadness",
      statement_descriptor: "PoolMadness Brackets",
      metadata: { bracket_ids: brackets.map(&:id).to_s, email: user.email }
    )

    brackets.each(&:paid!)

    { charge: charge, pool: pool }
  }

  CreateCharge = GraphQL::Relay::Mutation.define do
    name "CreateCharge"
    description "Create a credit card charge for a group of brackets"

    input_field :poolId, !types.ID
    input_field :token, !types.String

    return_field :charge, Types::ChargeType
    return_field :pool, Types::PoolType

    resolve CREATE_CHARGE_LAMBDA
  end
end
