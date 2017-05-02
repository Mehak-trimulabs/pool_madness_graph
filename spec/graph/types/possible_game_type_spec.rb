require "rails_helper"

RSpec.describe Types::PossibleGameType do
  subject { Types::PossibleGameType }

  context "fields" do
    let(:fields) { %w[slot previousSlotOne previousSlotTwo nextGameSlot nextGamePosition firstTeam secondTeam winningTeam losingTeam roundNumber region] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
