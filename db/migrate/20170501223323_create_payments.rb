class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.belongs_to :user, foreign_key: true
      t.belongs_to :grant, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
