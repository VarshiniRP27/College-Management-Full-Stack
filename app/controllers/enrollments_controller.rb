class EnrollmentsController < ApplicationController
  before_action :require_admin!
  before_action :set_enrollment, only: %i[show edit update destroy]

  def index
    @enrollments = Enrollment
                   .includes(:student, :course)
                   .order(created_at: :desc)
  end

  def new
    @enrollment = Enrollment.new(
      enrolled_at: Time.current,
      status: "active"
    )
    load_form_data
  end

  def create
    @enrollment = Enrollments::Create.call(
      student: Student.find(enrollment_params[:student_id]),
      course: Course.find(enrollment_params[:course_id]),
      enrolled_at: enrollment_params[:enrolled_at],
      status: enrollment_params[:status]
    )

    EnrollmentConfirmationJob.perform_later(@enrollment.id)

    redirect_to enrollments_path,
                notice: "Student enrolled successfully. Confirmation email queued."
  rescue ActiveRecord::RecordInvalid => error
    @students = Student.order(:name)
    @courses = Course.order(:name)
    @enrollment = error.record

    flash.now[:alert] = error.record.errors.full_messages.to_sentence

    render :new, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    @students = Student.order(:name)
    @courses = Course.order(:name)

    flash.now[:alert] = "Student or course not found."

    render :new, status: :unprocessable_entity
  end

  def show
  end

  def edit
    load_form_data
  end

  def update
    if @enrollment.update(enrollment_params)
      redirect_to enrollments_path,
                  notice: "Enrollment updated successfully."
    else
      load_form_data

      flash.now[:alert] =
        @enrollment.errors.full_messages.to_sentence

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @enrollment.destroy!

    redirect_to enrollments_path,
                notice: "Enrollment deleted successfully."
  end

  private

  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  def load_form_data
    @students = Student.order(:name)
    @courses = Course.order(:name)
  end

  def enrollment_params
    params.require(:enrollment).permit(
      :student_id,
      :course_id,
      :enrolled_at,
      :status
    )
  end

  def require_admin!
    return if admin_logged_in?

    redirect_to root_path, alert: "Admin access required."
  end
end
