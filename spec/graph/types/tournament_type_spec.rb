require "rails_helper"

RSpec.describe Types::TournamentType do
  subject { Types::TournamentType }

  context "fields" do
    let(:fields) { %w[id name gamesRemaining archived tipOff rounds teams gameMask gameDecisions] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end

    describe "tip_off" do
      subject { Types::TournamentType.fields["tipOff"] }

      let(:tip_off) { 2.days.ago.change(usec: 0) }
      let(:tournament) { create(:tournament, tip_off: tip_off) }

      it "is the string representation of the tip_off Time (iso8601)" do
        result = subject.resolve(tournament, nil, nil)
        expect(result).to eq(tip_off.iso8601)
        expect(Time.iso8601(result)).to eq(tip_off)
      end
    end
  end

  context "bitmasks" do
    let(:tournament) { create(:tournament, :completed) }
    let(:user) { create(:admin_user) }
    let(:context) { { current_user: user, current_ability: Ability.new(user) } }
    let(:resolved) { subject.resolve(tournament, nil, context) }

    describe "game_decisions" do
      subject { Types::TournamentType.fields["gameDecisions"] }

      it "is a string of zeros and ones representing the bracket decisions" do
        expect(resolved).to eq(Array.new(2**tournament.num_rounds) { |i| (tournament.game_decisions & (1 << i)).zero? ? "0" : "1" }.join)
      end
    end

    describe "game_mask" do
      subject { Types::TournamentType.fields["gameMask"] }

      it "is a string of zeros and ones representing the bracket bitmask" do
        expect(resolved).to eq(Array.new(2**tournament.num_rounds) { |i| (tournament.game_mask & (1 << i)).zero? ? "0" : "1" }.join)
      end
    end
  end
end
