class Api::V1::BaseController < ApplicationController
  skip_forgery_protection

  before_action :authenticate_api_token!

  attr_reader :current_api_user

  private

  def authenticate_api_token!
    token = request.headers["Authorization"].to_s.sub(/\ABearer\s+/i, "")

    if token.blank?
      return render json: {
        error: "Authorization token is required"
      }, status: :unauthorized
    end

    api_token = ApiToken.find_by(token: token)

    if api_token.nil?
      return render json: {
        error: "Invalid authorization token"
      }, status: :unauthorized
    end

    if api_token.expires_at.present? && api_token.expires_at <= Time.current
      return render json: {
        error: "Authorization token has expired"
      }, status: :unauthorized
    end

    @current_api_user =
      case api_token.user_type
      when "Admin"
        Admin.find_by(id: api_token.user_id)
      when "Teacher"
        Teacher.find_by(id: api_token.user_id)
      when "Student"
        Student.find_by(id: api_token.user_id)
      end

    unless @current_api_user
      render json: {
        error: "User not found"
      }, status: :unauthorized
    end
  end

  def require_admin!
    return if current_api_user.is_a?(Admin)

    render json: {
      error: "Forbidden",
      message: "Admin access required"
    }, status: :forbidden
  end

  def require_teacher_or_admin!
    return if current_api_user.is_a?(Admin) ||
              current_api_user.is_a?(Teacher)

    render json: {
      error: "Forbidden",
      message: "Teacher or Admin access required"
    }, status: :forbidden
  end

  def require_student_or_admin!
    return if current_api_user.is_a?(Admin) ||
              current_api_user.is_a?(Student)

    render json: {
      error: "Forbidden",
      message: "Student or Admin access required"
    }, status: :forbidden
  end
end
