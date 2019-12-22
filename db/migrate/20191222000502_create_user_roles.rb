class CreateUserRoles < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :roles, table_name: :user_roles, column_options: { null: false, foreign_key: true }
    add_column :user_roles, :id, :primary_key
  end
end
