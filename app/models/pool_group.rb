class PoolGroup < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :admins, -> { where(memberships: { admin: true }) }, class_name: "User", source: "user", through: :memberships

  validates :name, presence: true, uniqueness: true
end
