class UseUuidAsPrimaryKeys < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')

    table_associations = {
        bracket_points: [],
        brackets: [:bracket_points],
        pool_users: [],
        pools: [:brackets, :pool_users],
        teams: [],
        tournaments: [:pools, :teams],
        users: [:brackets, :pool_users]
    }

    table_associations.each do |table_name, associated_tables|
      add_column table_name, :uuid, :uuid, default: "uuid_generate_v4()", null: false
      rename_column table_name, :id, :model_id
      rename_column table_name, :uuid, :id
      execute "ALTER TABLE #{table_name} DROP CONSTRAINT #{table_name}_pkey;"
      execute "ALTER TABLE #{table_name} ADD PRIMARY KEY (id);"
      associated_tables.each do |associated_table_name|
        singular_name = table_name.to_s.chars[0...-1].join
        id_column = "#{singular_name}_id"
        uuid_column = "#{singular_name}_uuid"
        add_column associated_table_name, uuid_column, :uuid
        execute "UPDATE #{associated_table_name} SET #{uuid_column} = #{table_name}.id FROM #{table_name} WHERE #{table_name}.model_id = #{associated_table_name}.#{id_column}"
        remove_column associated_table_name, id_column
        rename_column associated_table_name, uuid_column, id_column
        add_index associated_table_name, id_column
      end
    end

    add_column :brackets, :payment_collector_uuid, :uuid
    execute "UPDATE brackets set payment_collector_uuid = users.id FROM users WHERE brackets.payment_collector_id = users.model_id"
    remove_column :brackets, :payment_collector_id
    rename_column :brackets, :payment_collector_uuid, :payment_collector_id
    add_index :brackets, :payment_collector_id

    table_associations.keys.each do |table_name|
      remove_column table_name, :model_id
    end
  end
end
