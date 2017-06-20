class RemoveRelationshipFromProfiles < ActiveRecord::Migration[5.0]
  def change
        remove_column :profiles, :relationship, :text
  end
end
