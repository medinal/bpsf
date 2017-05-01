class AddFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :stripe_token, :string
    add_column :users, :teacher, :boolean
    add_column :users, :approved, :boolean
    add_column :users, :type, :string
  end
end
