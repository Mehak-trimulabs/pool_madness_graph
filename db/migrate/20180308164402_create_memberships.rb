class CreateMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :pool_group_id, null: false
      t.boolean :admin, default: false, null: false
      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :pool_group_id
    add_index :memberships, [:user_id, :pool_group_id], unique: true
  end
end
