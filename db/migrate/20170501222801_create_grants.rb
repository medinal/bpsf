class CreateGrants < ActiveRecord::Migration[5.0]
  def change
    create_table :grants do |t|
      t.text :title
      t.text :summary
      t.text :subject_areas
      t.text :grade_level
      t.text :duration
      t.integer :num_classes
      t.integer :num_students
      t.integer :total_budget
      t.text :funds_will_pay_for
      t.text :budget_desc
      t.text :purpose
      t.text :methods
      t.text :background
      t.integer :num_collabs
      t.text :collaborators
      t.text :comments
      t.belongs_to :user, foreign_key: true
      t.string :state
      t.string :video
      t.string :image
      t.belongs_to :school, foreign_key: true
      t.integer :status
      t.date :deadline

      t.timestamps
    end
  end
end
