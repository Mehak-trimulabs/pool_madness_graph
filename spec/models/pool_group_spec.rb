require "rails_helper"

RSpec.describe PoolGroup do
  describe "validations" do
    subject { build(:pool_group) }

    # has a valid factory
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "associations" do
    subject { create(:pool_group) }

    it { is_expected.to have_many(:users).through(:memberships) }
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:admins).through(:memberships) }

    describe "#admins" do
      let!(:admin_membership) { create(:membership, pool_group: subject, admin: true) }
      let!(:pool_admin) { admin_membership.user }
      let!(:pool_user) { create(:membership, pool_group: subject).user }

      it { is_expected.to have_many(:admins).through(:memberships) }

      it "contains the admin" do
        expect(subject.admins).to eq([pool_admin])
      end

      it "does not contain a regular member" do
        expect(subject.users).to include(pool_user)
        expect(subject.admins).to_not include(pool_user)
      end
    end
  end
end
