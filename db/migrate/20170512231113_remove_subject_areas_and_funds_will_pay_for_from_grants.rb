class RemoveSubjectAreasAndFundsWillPayForFromGrants < ActiveRecord::Migration[5.0]
  def change
    remove_column :grants, :subject_areas
    remove_column :grants, :funds_will_pay_for
  end
end
