class PoolsToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :pools, :pool_group_id, :uuid
    add_index :pools, :pool_group_id
  end
end
