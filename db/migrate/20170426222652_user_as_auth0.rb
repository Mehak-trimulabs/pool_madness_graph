class UserAsAuth0 < ActiveRecord::Migration[5.1]
  def change
    [
        :reset_password_token,
        :reset_password_sent_at,
        :remember_created_at,
        :sign_in_count,
        :current_sign_in_ip,
        :last_sign_in_ip,
        :confirmation_token,
        :confirmed_at,
        :confirmation_sent_at,
        :invitation_token,
        :invitation_sent_at,
        :invitation_accepted_at,
        :invitation_limit,
        :invited_by_id,
        :invited_by_type
    ].each do |column|
      remove_column :users, column
    end

    add_column :users, :auth0_id, :string
    add_index :users, :auth0_id, unique: true
  end
end
