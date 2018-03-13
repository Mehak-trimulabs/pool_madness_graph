require "rails_helper"

RSpec.describe Mutations::MarkBracketPaid do
  subject { Mutations::MARK_BRACKET_PAID_LAMBDA }

  let(:user) { create(:user) }
  let(:graphql_args) { args.deep_stringify_keys }
  let(:graphql_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graphql_result) { subject.call(nil, graphql_args, graphql_context) }

  context "not logged in" do
    let(:user) { nil }
    let(:args) { {} }

    it "raises an auth error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You must be signed in to update this information")
    end
  end

  context "logged in" do
    let(:bracket) { create(:bracket) }
    let(:args) { { bracketId: bracket.id } }

    context "user who is not a pool admin" do
      it "raises an auth error" do
        expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You cannot mark this bracket paid")
      end
    end

    context "user is a pool admin" do
      let!(:pool_user) { create(:pool_user, pool: bracket.pool, role: :admin) }
      let(:user) { pool_user.user }
      let(:pool) { bracket.pool }

      it "marks the bracket paid" do
        expect(bracket).to_not be_paid

        graphql_result

        expect(bracket.reload).to be_paid
      end

      it "sets the user as the payment collector" do
        expect(bracket.payment_collector).to be_nil

        graphql_result

        expect(bracket.reload.payment_collector).to eq(user)
      end
    end
  end
end
