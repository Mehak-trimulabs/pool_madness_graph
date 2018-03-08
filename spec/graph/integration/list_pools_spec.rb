require "rails_helper"

RSpec.describe "Querying the list of pools" do
  let(:query_string) do
    <<-QUERY
        query {
          viewer {
            pools {
              id
              tournament {
                id
              }
              name
              inviteCode
              entryFee
              totalCollected
              started
              displayBest
              admins {
                id
              }
              bracketCount
              brackets(first: 1000) {
                edges {
                  node {
                    id
                    name
                  }
                }
              }
            }
          }
        }
    QUERY
  end

  let!(:pools) { create_list :pool, 3 }

  let(:graph_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graph_args) { {} }
  let(:query_result) { execute_graph_query(query_string, graph_args, graph_context) }
  let(:pool_nodes) { query_result.dig("data", "viewer", "pools") }

  context "as an admin" do
    let(:user) { create(:admin_user) }

    it "is a list of all pools" do
      ids = pool_nodes.map { |pool_attrs| pool_attrs["id"] }
      expect(ids).to match_array(Pool.all.pluck(:id))

      pool_nodes.each do |pool_node|
        pool = Pool.find(pool_node["id"])
        expect(pool_node["name"]).to eq(pool.name)
      end
    end
  end

  context "as a regular user" do
    let(:pool) { pools.sample }
    let(:user) { create(:pool_user, pool: pool).user }

    it "is a list of all accessible pools" do
      ids = pool_nodes.map { |pool_attrs| pool_attrs["id"] }
      expect(ids).to match_array([pool.id])
      pool_node = pool_nodes.first
      pool = Pool.find(pool_node["id"])
      expect(pool_node["name"]).to eq(pool.name)
    end
  end

  context "as a guest" do
    let(:user) { nil }

    it "is an empty list" do
      expect(pool_nodes).to match_array([])
    end
  end
end
