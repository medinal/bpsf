class ChangeDateTimeToDateInProfiles < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :started_teaching
    add_column :profiles, :started_teaching, :date
  end
end
