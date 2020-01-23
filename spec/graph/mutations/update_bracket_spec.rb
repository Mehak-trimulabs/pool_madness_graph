require "rails_helper"

RSpec.describe Mutations::UpdateBracket do
  subject { Mutations::UPDATE_BRACKET_LAMBDA }

  let(:tournament) { create(:tournament, :not_started) }
  let(:pool) { create(:pool, tournament: tournament) }
  let(:bracket) { create(:bracket, pool: pool) }
  let(:user) { bracket.user }

  let(:graphql_args) { args.deep_stringify_keys }
  let(:graphql_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graphql_result) { subject.call(nil, graphql_args, graphql_context) }

  let(:completed_bracket) { create(:bracket, :completed, pool: pool) }
  let(:name) { Faker::Lorem.words(number: 2).join(" ") }
  let(:tie_breaker) { Faker::Number.between(from: 50, to: 120) }
  let(:game_decisions) { Array.new(2**bracket.tournament.num_rounds) { |i| (completed_bracket.tree_decisions & (1 << i)).zero? ? "0" : "1" }.join("") }
  let(:game_mask) { Array.new(2**bracket.tournament.num_rounds) { |i| (completed_bracket.tree_mask & (1 << i)).zero? ? "0" : "1" }.join("") }

  let(:args) do
    {
      bracketId: bracket.id,
      name: name,
      tieBreaker: tie_breaker,
      gameDecisions: game_decisions,
      gameMask: game_mask
    }
  end

  context "with valid data" do
    before do
      graphql_result
      bracket.reload
    end

    it "updates the bracket" do
      expect(bracket.name).to eq(name)
      expect(bracket.tie_breaker).to eq(tie_breaker)
      expect(bracket.tree_decisions).to eq(completed_bracket.tree_decisions)
      expect(bracket.tree_mask).to eq(completed_bracket.tree_mask)
    end

    it "includes the updated bracket in the result" do
      expect(graphql_result[:bracket]).to eq(bracket)
    end
  end

  context "with invalid data" do
    let!(:original_name) { bracket.name }
    let(:name) { completed_bracket.name }

    before do
      graphql_result
      bracket.reload
    end

    it "has the validation errors" do
      expect(graphql_result[:errors][:name]).to include("has already been taken")
    end

    it "does not update the bracket" do
      expect(bracket.name).to eq(original_name)
    end
  end

  context "not logged in" do
    let(:user) { nil }
    let(:args) { {} }

    it "raises an auth error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You must be signed in to update this information")
    end
  end

  context "user who cannot update the bracket" do
    let(:user) { completed_bracket.user }

    it "raises an auth error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You cannot update this bracket")
    end
  end
end
