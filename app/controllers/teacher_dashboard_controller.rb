class TeacherDashboardController < ApplicationController
  before_action :require_teacher

  def index
    @teacher = Teacher.find(session[:teacher_id])

    @courses = @teacher.courses

    @students = Student
                .where(course_id: @courses.select(:id))
                .includes(:course)
                .order(:name)
  end

  private

  def require_teacher
    unless session[:teacher_id]
      redirect_to teacher_login_path,
                  alert: "Please login as a teacher."
    end
  end
end
