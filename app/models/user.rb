class User < ApplicationRecord
  has_many :brackets, dependent: :destroy
  has_many :brackets_to_pay, class_name: "Bracket", foreign_key: "payment_collector_id"
  has_many :pool_users, dependent: :destroy
  has_many :pools, through: :pool_users

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EmailValidator.regexp }

  enum role: %i[regular admin]

  def stripe_customer
    if stripe_customer_id.present?
      Stripe::Customer.retrieve(stripe_customer_id)
    else
      customer = Stripe::Customer.create(email: email)
      self.stripe_customer_id = customer.id
      save!
      customer
    end
  end
end
