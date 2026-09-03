class Api::V1::AuthController < ApplicationController
  skip_forgery_protection

  def register
    user = build_user

    if user.save
      render json: {
        data: {
          message: "Registration successful",
          user_type: user.class.name,
          user_id: user.id,
          name: user.name,
          email: user.email
        }
      }, status: :created
    else
      render json: {
        errors: user.errors.to_hash
      }, status: :unprocessable_entity
    end
  end

  def login
    user = find_user

    unless user&.authenticate(params[:password])
      return render json: {
        error: "Invalid username/email or password"
      }, status: :unauthorized
    end

    token = SecureRandom.hex(32)

    api_token = ApiToken.create!(
      token: token,
      user_type: user.class.name,
      user_id: user.id,
      expires_at: 24.hours.from_now
    )

    render json: {
      data: {
        token: api_token.token,
        user_type: api_token.user_type,
        user_id: api_token.user_id,
        expires_at: api_token.expires_at
      }
    }
  end

  private

  def build_user
    case params[:user_type].to_s.downcase
    when "student"
      Student.new(
        name: params[:name],
        email: params[:email],
        age: params[:age],
        marks: params[:marks],
        course_id: params[:course_id],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )

    when "teacher"
      Teacher.new(
        name: params[:name],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )

    else
      raise ActionController::BadRequest,
            "user_type must be student or teacher"
    end
  end

  def find_user
    if params[:username].present?
      Admin.find_by(username: params[:username])
    elsif params[:email].present?
      Student.find_by(email: params[:email]) ||
        Teacher.find_by(email: params[:email])
    end
  end
end
