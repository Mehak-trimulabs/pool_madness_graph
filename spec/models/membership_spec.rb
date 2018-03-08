require "rails_helper"

RSpec.describe Membership, type: :model do
  subject { build(:membership) }

  it { is_expected.to be_valid }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:pool_group) }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:pool_group_id).case_insensitive }

  it "defaults admin to false" do
    expect(subject).to_not be_admin
  end
end
