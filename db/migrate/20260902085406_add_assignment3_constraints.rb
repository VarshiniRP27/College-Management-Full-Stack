class AddAssignment3Constraints < ActiveRecord::Migration[8.1]
  def change
    add_index :students, :email, unique: true
    add_index :courses, :name, unique: true
  end
end
