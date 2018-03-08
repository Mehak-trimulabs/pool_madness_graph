require "rails_helper"

RSpec.describe "Querying the current user" do
  let(:query_string) do
    <<-QUERY
      query {
        viewer {
          currentUser {
            name
            email
          }
        }
      }
    QUERY
  end

  let(:graph_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graph_args) { {} }
  let(:query_result) { execute_graph_query(query_string, graph_args, graph_context) }
  let(:current_user_node) { query_result.dig("data", "viewer", "currentUser") }

  context "with a logged in user" do
    let(:user) { create(:user) }

    it "is the logged in user" do
      expect(current_user_node["name"]).to eq(user.name)
      expect(current_user_node["email"]).to eq(user.email)
    end
  end

  context "as a guest" do
    let(:user) { nil }

    it "is blank" do
      expect(current_user_node).to be_nil
    end
  end
end
