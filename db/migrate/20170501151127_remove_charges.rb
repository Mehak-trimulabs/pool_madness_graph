class RemoveCharges < ActiveRecord::Migration[5.1]
  def change
    drop_table :charges
    remove_column :brackets, :charge_id
    remove_column :brackets, :stripe_charge_id
  end
end
