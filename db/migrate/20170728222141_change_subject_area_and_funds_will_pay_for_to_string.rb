class ChangeSubjectAreaAndFundsWillPayForToString < ActiveRecord::Migration[5.0]
  def change
    change_column :grants, :funds_will_pay_for, :string
    change_column :grants, :subject_areas, :string
  end
end
