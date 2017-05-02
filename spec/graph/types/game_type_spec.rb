require "rails_helper"

RSpec.describe Types::GameType do
  subject { Types::GameType }

  context "fields" do
    let(:fields) { %w[id slot previousSlotOne previousSlotTwo nextGameSlot nextGamePosition firstTeam secondTeam winningTeam losingTeam roundNumber region] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
