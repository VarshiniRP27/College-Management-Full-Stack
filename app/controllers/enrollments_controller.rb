class EnrollmentsController < ApplicationController

  before_action :require_admin,
                except: [:index, :show]

  before_action :set_enrollment,
                only: [:show, :edit, :update, :destroy]


  def index
    @enrollments = Enrollment
                    .includes(:student, :course)
                    .order(created_at: :desc)
  end


  def show
  end


  def new
    @enrollment = Enrollment.new

    @students = Student.order(:name)
    @courses = Course.order(:name)
  end


  def create
    @enrollment = Enrollment.new(enrollment_params)

    if @enrollment.save
      redirect_to @enrollment,
                  notice: "Student was successfully enrolled."
    else
      @students = Student.order(:name)
      @courses = Course.order(:name)

      render :new,
             status: :unprocessable_entity
    end
  end


  def edit
    @students = Student.order(:name)
    @courses = Course.order(:name)
  end


  def update
    if @enrollment.update(enrollment_params)
      redirect_to @enrollment,
                  notice: "Enrollment was successfully updated."
    else
      @students = Student.order(:name)
      @courses = Course.order(:name)

      render :edit,
             status: :unprocessable_entity
    end
  end


  def destroy
    @enrollment.destroy

    redirect_to enrollments_path,
                notice: "Enrollment was successfully deleted."
  end


  private


  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end


  def enrollment_params
    params.require(:enrollment).permit(
      :student_id,
      :course_id,
      :enrolled_at,
      :status
    )
  end

end