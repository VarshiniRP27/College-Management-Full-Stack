class StudentsController < ApplicationController
  before_action :require_student_or_admin
  before_action :set_student, only: %i[show edit update destroy]

  def index
    @students = Student
                .includes(:course)
                .order(created_at: :desc)

    @courses = Course.order(:name)

    if params[:course_id].present?
      @students = @students.where(course_id: params[:course_id])
    end

    @pagy, @students = pagy(@students)
  end

  def show
    unless admin_logged_in? || current_student&.id == @student.id
      redirect_to student_dashboard_path,
                  alert: "You can only view your own profile."
    end
  end

  def new
    require_admin!

    @student = Student.new
  end

  def create
    require_admin!

    @student = Student.new(student_params)

    if @student.save
      redirect_to @student,
                  notice: "Student was successfully created."
    else
      render :new,
             status: :unprocessable_entity
    end
  end

  def edit
    unless admin_logged_in? || current_student&.id == @student.id
      redirect_to student_dashboard_path,
                  alert: "You can only edit your own profile."
    end
  end

  def update
    unless admin_logged_in? || current_student&.id == @student.id
      redirect_to student_dashboard_path,
                  alert: "You can only edit your own profile."
      return
    end

    attributes =
      if admin_logged_in?
        student_params
      else
        student_profile_params
      end

    if @student.update(attributes)
      redirect_to student_dashboard_path,
                  notice: "Your profile was successfully updated."
    else
      render :edit,
             status: :unprocessable_entity
    end
  end

  def destroy
    require_admin!

    @student.destroy!

    redirect_to students_path,
                notice: "Student was successfully deleted."
  end

  def statistics
    require_admin!

    @students = Student.all

    @total_students = @students.count

    @passed_students =
      @students.where("marks >= ?", 40).count

    @failed_students =
      @students.where("marks < ?", 40).count

    if @total_students > 0
      @pass_percentage =
        (
          @passed_students.to_f /
          @total_students *
          100
        ).round(2)
    else
      @pass_percentage = 0
    end

    marks =
      @students
              .where.not(marks: nil)
              .pluck(:marks)
              .map(&:to_f)

    if marks.any?
      @highest_marks = marks.max
      @lowest_marks = marks.min
      @average_marks = (marks.sum / marks.length).round(2)

      @highest_student =
        @students
        .where(marks: @highest_marks)
        .first

      @lowest_student =
        @students
        .where(marks: @lowest_marks)
        .first
    else
      @highest_marks = 0
      @lowest_marks = 0
      @average_marks = 0
      @highest_student = nil
      @lowest_student = nil
    end
  end

  def find
    @students = Student
                .includes(:course)
                .order(:name)

    if params[:id].present?
      if params[:id].to_s.match?(/\A\d+\z/)
        @students = @students.where(id: params[:id])
      else
        @students = Student.none
      end

    elsif params[:name].present?
      @students =
        @students.where(
          "name ILIKE ?",
          "%#{params[:name]}%"
        )

    elsif params[:course_id].present?
      @students =
        @students.where(
          course_id: params[:course_id]
        )
    end
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def admin_logged_in?
    session[:admin_id].present?
  end

  def current_student
    return nil unless session[:student_id].present?

    @current_student ||= Student.find_by(
      id: session[:student_id]
    )
  end

  def require_student_or_admin
    return if admin_logged_in?
    return if session[:student_id].present?

    redirect_to root_path,
                alert: "Please login first."
  end

  def require_admin!
    return if admin_logged_in?

    redirect_to student_dashboard_path,
                alert: "Admin access required."
  end

  def student_params
    params
      .require(:student)
      .permit(
        :name,
        :email,
        :age,
        :marks,
        :course_id,
        :branch,
        :password,
        :password_confirmation
      )
  end

  def student_profile_params
    params
      .require(:student)
      .permit(
        :name,
        :email,
        :age,
        :password,
        :password_confirmation
      )
  end
end