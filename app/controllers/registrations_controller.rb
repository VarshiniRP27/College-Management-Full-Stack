class RegistrationsController < ApplicationController
  def student_new
    @student = Student.new
  end

  def student_create
    @student = Student.new(student_params)

    if @student.save
      redirect_to student_login_path,
                  notice: "Student registration successful. Please login."
    else
      render :student_new, status: :unprocessable_entity
    end
  end

  def teacher_new
    @teacher = Teacher.new
  end

  def teacher_create
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      redirect_to teacher_login_path,
                  notice: "Teacher registration successful. Please login."
    else
      render :teacher_new, status: :unprocessable_entity
    end
  end

  private

  def student_params
    params.require(:student).permit(
      :name,
      :email,
      :age,
      :marks,
      :course_id,
      :password,
      :password_confirmation
    )
  end

  def teacher_params
    params.require(:teacher).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
