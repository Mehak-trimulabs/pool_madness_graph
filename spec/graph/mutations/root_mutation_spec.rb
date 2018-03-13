require "rails_helper"

RSpec.describe Mutations::RootMutation do
  subject { described_class }

  context "fields" do
    let(:fields) { %w[createCharge acceptInvitation updateProfile createBracket updateBracket deleteBracket markBracketPaid] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
