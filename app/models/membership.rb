class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :pool_group

  validates :user_id, uniqueness: { scope: :pool_group_id }
end
