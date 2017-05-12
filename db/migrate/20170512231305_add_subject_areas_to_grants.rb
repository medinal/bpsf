class AddSubjectAreasToGrants < ActiveRecord::Migration[5.0]
  def change
    add_column :grants, :subject_areas, :integer
  end
end
