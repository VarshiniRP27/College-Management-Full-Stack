class StudentDashboardController < ApplicationController
  before_action :require_student

  def index
    @student = Student.find(session[:student_id])
  end

  private

  def require_student
    unless session[:student_id]
      redirect_to student_login_path, alert: "Please login first."
    end
  end
end