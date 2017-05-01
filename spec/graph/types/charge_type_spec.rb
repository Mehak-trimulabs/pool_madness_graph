require "rails_helper"

RSpec.describe Types::ChargeType do
  subject { Types::ChargeType }

  context "fields" do
    let(:fields) { %w[stripe_id amount description] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
