require "rails_helper"

RSpec.describe Types::PossibilityType do
  subject { Types::PossibilityType }

  context "fields" do
    let(:fields) { %w[championships firstPlace secondPlace thirdPlace] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
