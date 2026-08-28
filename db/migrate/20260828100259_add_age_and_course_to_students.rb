class AddAgeAndCourseToStudents < ActiveRecord::Migration[8.1]
  def change
    add_column :students, :age, :integer
    add_column :students, :course, :string
  end
end
