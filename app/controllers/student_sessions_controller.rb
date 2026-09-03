class StudentSessionsController < ApplicationController
  def new
  end

  def create
    student = Student.find_by(email: params[:email])

    if student&.authenticate(params[:password])
      session.delete(:admin_id)
      session.delete(:teacher_id)
      session[:student_id] = student.id

      redirect_to root_path,
                  notice: "Login successful."
    else
      flash.now[:alert] = "Invalid email or password."

      render :new,
             status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:student_id)

    redirect_to root_path,
                notice: "Logged out successfully."
  end
end
