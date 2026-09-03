class TeacherSessionsController < ApplicationController
  def new
  end

  def create
    teacher = Teacher.find_by(email: params[:email])

    if teacher&.authenticate(params[:password])
      session.delete(:admin_id)
      session.delete(:student_id)
      session[:teacher_id] = teacher.id

      redirect_to root_path,
                  notice: "Login successful."
    else
      flash.now[:alert] = "Invalid email or password."

      render :new,
             status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:teacher_id)

    redirect_to root_path,
                notice: "Logged out successfully."
  end
end
