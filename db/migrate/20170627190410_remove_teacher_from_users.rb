class RemoveTeacherFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :teacher, :boolean
  end
end
