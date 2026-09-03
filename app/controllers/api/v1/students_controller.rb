class Api::V1::StudentsController < Api::V1::BaseController
  skip_forgery_protection

  before_action :authorize_student_update!, only: :update
  before_action :require_teacher_or_admin!, only: %i[create destroy]

  rescue_from ActiveRecord::RecordNotFound do
    render json: {
      error: "Student not found"
    }, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |error|
    render json: {
      errors: {
        parameter: [error.message]
      }
    }, status: :bad_request
  end

  def index
    students = Student.includes(:course).order(created_at: :desc)

    if params[:search].present?
      search = "%#{params[:search]}%"

      students = students.where(
        "name ILIKE :search OR email ILIKE :search",
        search: search
      )
    end

    if params[:course_id].present?
      students = students.where(course_id: params[:course_id])
    end

    if params[:min_marks].present?
      students = students.where("marks >= ?", params[:min_marks])
    end

    page = [params.fetch(:page, 1).to_i, 1].max

    per_page = [params.fetch(:per_page, 10).to_i, 1].max
    per_page = [per_page, 100].min

    total = students.count

    students = students
               .offset((page - 1) * per_page)
               .limit(per_page)

    render json: {
      data: students.as_json(
        only: %i[
          id
          name
          email
          age
          marks
          course_id
          created_at
          updated_at
        ]
      ),
      meta: {
        page: page,
        per_page: per_page,
        total: total
      }
    }
  end

  def statistics
    total_students = Student.count
    average_marks = Student.average(:marks)
    highest_marks = Student.maximum(:marks)
    lowest_marks = Student.minimum(:marks)

    passed_students = Student.where("marks >= ?", 40).count
    failed_students = Student.where("marks < ?", 40).count

    render json: {
      data: {
        total_students: total_students,
        average_marks: average_marks&.to_f&.round(2),
        highest_marks: highest_marks,
        lowest_marks: lowest_marks,
        passed_students: passed_students,
        failed_students: failed_students
      }
    }
  end

  def show
    student = Student.find(params[:id])

    if current_api_user.is_a?(Student) &&
       current_api_user.id != student.id
      return render json: {
        error: "Forbidden",
        message: "Students can only view their own record"
      }, status: :forbidden
    end

    render json: {
      data: student.as_json(
        only: %i[
          id
          name
          email
          age
          marks
          course_id
          created_at
          updated_at
        ]
      )
    }
  end

  def create
    student = Student.new(student_params)

    if student.save
      render json: {
        data: student.as_json(
          only: %i[
            id
            name
            email
            age
            marks
            course_id
            created_at
            updated_at
          ]
        )
      }, status: :created
    else
      render json: {
        errors: student.errors.to_hash
      }, status: :unprocessable_entity
    end
  end

  def update
    student = Student.find(params[:id])

    attributes =
      if current_api_user.is_a?(Student)
        student_update_params
      else
        student_params
      end

    if student.update(attributes)
      render json: {
        data: student.as_json(
          only: %i[
            id
            name
            email
            age
            marks
            course_id
            created_at
            updated_at
          ]
        )
      }
    else
      render json: {
        errors: student.errors.to_hash
      }, status: :unprocessable_entity
    end
  end

  def destroy
    student = Student.find(params[:id])
    student.destroy!

    render json: {
      message: "Student deleted successfully"
    }
  end

  private

  def authorize_student_update!
    student = Student.find(params[:id])

    return if current_api_user.is_a?(Admin)
    return if current_api_user.is_a?(Teacher)

    if current_api_user.is_a?(Student) &&
       current_api_user.id == student.id
      return
    end

    render json: {
      error: "Forbidden",
      message: "You can only update your own student record"
    }, status: :forbidden
  end

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

  def student_update_params
    params.require(:student).permit(
      :name,
      :email,
      :age,
      :password,
      :password_confirmation
    )
  end
end
