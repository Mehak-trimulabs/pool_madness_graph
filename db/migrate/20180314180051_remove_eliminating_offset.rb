class RemoveEliminatingOffset < ActiveRecord::Migration[5.1]
  def change
    remove_column :tournaments, :eliminating_offset
  end
end
