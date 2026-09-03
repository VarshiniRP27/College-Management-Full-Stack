class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[show edit update destroy]

  def index
    @teachers = Teacher.includes(:courses).order(:name)
  end

  def show
    @courses = @teacher.courses.order(:name)

    @students = Student
                .where(course_id: @courses.select(:id))
                .order(:name)
  end

  def new
    @teacher = Teacher.new
  end

  def edit
  end

  def create
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      redirect_to @teacher, notice: "Teacher was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @teacher.update(teacher_params)
      redirect_to @teacher, notice: "Teacher was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @teacher.destroy
    redirect_to teachers_path, notice: "Teacher was successfully deleted."
  end

  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def teacher_params
    params
      .require(:teacher)
      .permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        course_ids: []
      )
  end
end
