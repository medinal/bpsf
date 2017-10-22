class RemoveSubjectFromProfiles < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :subject, :string
  end
end
