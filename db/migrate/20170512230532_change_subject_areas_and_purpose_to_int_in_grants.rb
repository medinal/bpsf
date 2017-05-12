class ChangeSubjectAreasAndPurposeToIntInGrants < ActiveRecord::Migration[5.0]
  def change
    change_column :grants, :subject_areas, :integer
    change_column :grants, :funds_will_pay_for, :integer
  end
end
