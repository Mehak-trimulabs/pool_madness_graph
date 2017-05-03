require "rails_helper"

RSpec.describe Types::QueryType do
  subject { described_class }

  context "fields" do
    let(:fields) { %w[node nodes viewer] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end

  context "viewer" do
    subject { described_class.fields["viewer"] }

    it "is the viewer singleton" do
      expect(subject.resolve(nil, nil, {}).id).to eq(Viewer::ID)
    end
  end

  context "node" do
    subject { described_class.fields["node"] }
    let(:bracket) { create(:bracket) }
    let(:user) { bracket.user }
    let(:ability) { Ability.new(user) }
    let(:args) { { id: bracket.id } }

    context "signed in" do
      context "as the bracket owner" do
        it "is the bracket" do
          expect(subject.resolve(nil, args, current_user: user, current_ability: ability)).to eq(bracket)
        end
      end

      context "as a user without access" do
        let(:another_user) { create(:user) }
        let(:another_ability) { Ability.new(another_user) }

        it "is nil" do
          result = subject.resolve(nil, args, current_user: another_user, current_ability: another_ability)
          expect(result).to be_nil
        end
      end
    end

    context "not signed in" do
      it "is nil" do
        result = subject.resolve(nil, args, current_user: nil, current_ability: Ability.new(nil))
        expect(result).to be_nil
      end
    end
  end
end
