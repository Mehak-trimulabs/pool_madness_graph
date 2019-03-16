class User < ApplicationRecord
  has_many :brackets, dependent: :destroy
  has_many :brackets_to_pay, class_name: "Bracket", foreign_key: "payment_collector_id", inverse_of: :payment_collector, dependent: :nullify

  has_many :pool_users, dependent: :destroy
  has_many :pools, through: :pool_users

  has_many :memberships, dependent: :destroy
  has_many :pool_groups, through: :memberships

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :auth0_id, presence: true, uniqueness: true
  validates :name, presence: true
end
