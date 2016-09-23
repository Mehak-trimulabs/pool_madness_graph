require "rails_helper"

RSpec.describe Queries::GameType do
  subject { Queries::GameType }

  context "fields" do
    let(:fields) { %w(id slot previous_slot_one previous_slot_two next_game_slot next_game_position team_one team_two winning_team choice) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
