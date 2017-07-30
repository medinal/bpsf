class RemoveStateFromGrants < ActiveRecord::Migration[5.0]
  def change
    remove_column :grants, :state, :string
  end
end
