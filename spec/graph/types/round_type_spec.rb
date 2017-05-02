require "rails_helper"

RSpec.describe Types::RoundType do
  subject { Types::RoundType }
  let(:round) { build(:round) }

  context "fields" do
    let(:fields) { %w[id name number startDate endDate regions] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end

  describe "start_date" do
    subject { Types::RoundType.fields["startDate"] }

    it "is an iso 8601 string representing the round start date" do
      expect(subject.resolve(round, nil, nil)).to eq(round.start_date.iso8601)
    end
  end

  describe "end_date" do
    subject { Types::RoundType.fields["endDate"] }

    it "is an iso 8601 string representing the round end date" do
      expect(subject.resolve(round, nil, nil)).to eq(round.end_date.iso8601)
    end
  end
end
