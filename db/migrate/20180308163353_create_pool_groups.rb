class CreatePoolGroups < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'

    create_table :pool_groups, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :pool_groups, :name, unique: true
  end
end
