class AddFundsWillPayForToGrants < ActiveRecord::Migration[5.0]
  def change
    add_column :grants, :funds_will_pay_for, :integer
  end
end
