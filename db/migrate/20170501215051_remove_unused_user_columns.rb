class RemoveUnusedUserColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :stripe_customer_id
  end
end
