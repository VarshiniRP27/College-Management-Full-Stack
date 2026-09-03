class Api::V1::CoursesController < Api::V1::BaseController
  skip_forgery_protection

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Course not found" }, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |error|
    render json: {
      errors: {
        parameter: [ error.message ]
      }
    }, status: :bad_request
  end

  def index
    courses = Course
              .includes(:teacher)
              .order(created_at: :desc)

    page = [ params.fetch(:page, 1).to_i, 1 ].max
    per_page = [ params.fetch(:per_page, 10).to_i, 1 ].max
    per_page = [ per_page, 100 ].min

    total = courses.count

    courses = courses
               .offset((page - 1) * per_page)
               .limit(per_page)

    render json: {
      data: courses.as_json(
        only: %i[
          id
          name
          description
          teacher_id
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

  def show
    course = Course.find(params[:id])

    render json: {
      data: course.as_json(
        only: %i[
          id
          name
          description
          teacher_id
          created_at
          updated_at
        ]
      )
    }
  end

  def create
    course = Course.new(course_params)

    if course.save
      render json: {
        data: course.as_json(
          only: %i[
            id
            name
            description
            teacher_id
            created_at
            updated_at
          ]
        )
      }, status: :created
    else
      render json: {
        errors: course.errors.to_hash
      }, status: :unprocessable_entity
    end
  end

  def update
    course = Course.find(params[:id])

    if course.update(course_params)
      render json: {
        data: course.as_json(
          only: %i[
            id
            name
            description
            teacher_id
            created_at
            updated_at
          ]
        )
      }
    else
      render json: {
        errors: course.errors.to_hash
      }, status: :unprocessable_entity
    end
  end

  def destroy
    course = Course.find(params[:id])
    course.destroy!

    render json: {
      message: "Course deleted successfully"
    }
  end

  private

  def course_params
    params.require(:course).permit(
      :name,
      :description,
      :teacher_id
    )
  end
end
