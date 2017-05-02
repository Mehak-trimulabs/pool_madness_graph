require "rails_helper"

RSpec.describe Types::TeamType do
  subject { Types::TeamType }

  context "fields" do
    let(:fields) { %w[id name seed startingSlot] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
