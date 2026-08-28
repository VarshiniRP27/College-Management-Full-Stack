class StudentsController < ApplicationController

  before_action :set_student,
                only: %i[show edit update destroy]

  before_action :require_admin,
                only: %i[new create edit update destroy]


  # =========================
  # Students List
  # =========================
def index

  # Get all students
  @students = Student
              .includes(:course)
              .order(created_at: :desc)


  # Get available course names for the filter
  @courses = Student
             .where.not(course: [nil, ""])
             .distinct
             .order(:course)
             .pluck(:course)


  # Filter by course if selected
  if params[:course].present?

    @students = @students.where(
      course: params[:course]
    )

  end


  # Pagination
  @pagy, @students = pagy(@students)

end
  


  # =========================
  # Show Student
  # =========================

  def show
  end


  # =========================
  # New Student
  # =========================

  def new
    @student = Student.new
  end


  # =========================
  # Create Student
  # =========================

  def create
    @student = Student.new(student_params)

    if @student.save

      redirect_to @student,
                  notice: "Student was successfully created."

    else

      render :new,
             status: :unprocessable_entity

    end
  end


  # =========================
  # Edit Student
  # =========================

  def edit
  end


  # =========================
  # Update Student
  # =========================

  def update
    if @student.update(student_params)

      redirect_to @student,
                  notice: "Student was successfully updated."

    else

      render :edit,
             status: :unprocessable_entity

    end
  end


  # =========================
  # Delete Student
  # =========================

  def destroy
    @student.destroy!

    redirect_to students_path,
                notice: "Student was successfully deleted."

  end


  # =========================
  # Statistics
  # =========================

  def statistics

    @students = Student.all

    @total_students = @students.count

    @passed_students = @students
                       .select { |student| student.result == "PASS" }
                       .count

    @failed_students = @students
                       .select { |student| student.result == "FAIL" }
                       .count

    if @total_students > 0
      @pass_percentage =
        (@passed_students.to_f / @total_students * 100).round(2)
    else
      @pass_percentage = 0
    end

  end


  # =========================
  # Find Student
  # =========================

  def find

    @students = Student
                .includes(:course)
                .order(:name)

    if params[:name].present?

      @students = @students.where(
        "name LIKE ?",
        "%#{params[:name]}%"
      )

    end

    if params[:course_id].present?

      @students = @students.where(
        course_id: params[:course_id]
      )

    end

  end


  private


  # =========================
  # Find Student
  # =========================

  def set_student
    @student = Student.find(params[:id])
  end


  # =========================
  # Strong Parameters
  # =========================

  def student_params

    params.require(:student).permit(
      :name,
      :email,
      :age,
      :marks,
      :course_id,
      :branch,
      :course
    )

  end

end