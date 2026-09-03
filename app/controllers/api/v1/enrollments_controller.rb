class Api::V1::EnrollmentsController < Api::V1::BaseController
  skip_forgery_protection

  before_action :require_teacher_or_admin!, only: %i[create destroy]

  rescue_from ActiveRecord::RecordNotFound do
    render json: {
      error: "Enrollment not found"
    }, status: :not_found
  end

  def index
    enrollments = Enrollment
                  .includes(:student, :course)
                  .order(created_at: :desc)

    render json: {
      data: enrollments.map { |enrollment| enrollment_json(enrollment) }
    }
  end

  def show
    enrollment = Enrollment
                 .includes(:student, :course)
                 .find(params[:id])

    render json: {
      data: enrollment_json(enrollment)
    }
  end

  def create
    enrollment = Enrollments::Create.call(
      student: Student.find(enrollment_params[:student_id]),
      course: Course.find(enrollment_params[:course_id]),
      enrolled_at: enrollment_params[:enrolled_at],
      status: enrollment_params[:status]
    )

    EnrollmentConfirmationJob.perform_later(enrollment.id)

    render json: {
      data: enrollment_json(enrollment)
    }, status: :created

  rescue ActiveRecord::RecordInvalid => error
    render json: {
      errors: error.record.errors.to_hash
    }, status: :unprocessable_entity

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Student or course not found"
    }, status: :not_found
  end

  def destroy
    enrollment = Enrollment.find(params[:id])
    enrollment.destroy!

    render json: {
      message: "Enrollment deleted successfully"
    }
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(
      :student_id,
      :course_id,
      :enrolled_at,
      :status
    )
  end

  def enrollment_json(enrollment)
    {
      id: enrollment.id,
      student_id: enrollment.student_id,
      student_name: enrollment.student.name,
      course_id: enrollment.course_id,
      course_name: enrollment.course.name,
      enrolled_at: enrollment.enrolled_at,
      status: enrollment.status,
      created_at: enrollment.created_at,
      updated_at: enrollment.updated_at
    }
  end
end
