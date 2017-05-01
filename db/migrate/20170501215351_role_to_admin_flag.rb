class RoleToAdminFlag < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
    User.where(role: 1).each do |user|
      user.update(admin: true)
    end
    remove_column :users, :role
  end
end
