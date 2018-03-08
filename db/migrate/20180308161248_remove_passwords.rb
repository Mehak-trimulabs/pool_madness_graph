class RemovePasswords < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :encrypted_password
    change_column :users, :auth0_id, :string, null: false
    change_column :users, :name, :string, null: false
  end
end
