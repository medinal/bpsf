class AddChargeToPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :charge_id, :string
  end
end
