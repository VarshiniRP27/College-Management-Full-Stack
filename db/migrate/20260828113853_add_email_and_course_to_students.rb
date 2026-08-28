class AddEmailAndCourseToStudents < ActiveRecord::Migration[8.1]
  def change
    add_column :students, :email, :string

    add_reference :students,
                  :course,
                  null: true,
                  foreign_key: true
  end
end