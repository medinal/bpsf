class ChangeAmountOnPaymentsToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :payments, :amount, :decimal
  end
end
