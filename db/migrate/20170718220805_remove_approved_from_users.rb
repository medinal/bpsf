class RemoveApprovedFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :approved, :boolean
  end
end
