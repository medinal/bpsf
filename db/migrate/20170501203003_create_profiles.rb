class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.text :about
      t.string :address
      t.string :city
      t.string :position
      t.text :state
      t.text :zipcode
      t.string :grade
      t.string :home_phone
      t.string :work_phone
      t.string :subject
      t.text :relationship
      t.datetime :started_teaching
      t.references :school

      t.timestamps
    end
  end
end
