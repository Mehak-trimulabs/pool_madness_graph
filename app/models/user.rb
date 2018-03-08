class User < ApplicationRecord
  has_many :brackets, dependent: :destroy
  has_many :brackets_to_pay, class_name: "Bracket", foreign_key: "payment_collector_id", inverse_of: :payment_collector, dependent: :nullify
  has_many :pool_users, dependent: :destroy
  has_many :pools, through: :pool_users

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: EmailValidator.regexp }

  validates :auth0_id, presence: true, uniqueness: true
  validates :name, presence: true
end
