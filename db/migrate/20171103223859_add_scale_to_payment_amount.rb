class AddScaleToPaymentAmount < ActiveRecord::Migration[5.0]
  def change
    change_column :payments, :amount, :decimal, precision: 8, scale: 2
  end
end
