class AddNotNullConstraintsToStudents < ActiveRecord::Migration[8.1]
  def change
    change_column_null :students, :name, false
    change_column_null :students, :email, false
    change_column_null :students, :age, false
    change_column_null :students, :marks, false
  end
end
