require "rails_helper"
require "stripe_mock"

RSpec.describe User, type: :model do
  subject! { create(:user) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it { is_expected.to validate_presence_of(:auth0_id) }
  it { is_expected.to validate_uniqueness_of(:auth0_id) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_many(:brackets) }
  it { is_expected.to have_many(:brackets_to_pay) }
  it { is_expected.to have_many(:pool_users) }
  it { is_expected.to have_many(:pools).through(:pool_users) }
  it { is_expected.to have_many(:memberships).dependent(:destroy) }
  it { is_expected.to have_many(:pool_groups).through(:memberships) }

  it { is_expected.to allow_value("user@foo.com").for(:email) }
  it { is_expected.to allow_value("THE_USER@foo.bar.org").for(:email) }
  it { is_expected.to allow_value("first.last@foo.jp").for(:email) }
end
