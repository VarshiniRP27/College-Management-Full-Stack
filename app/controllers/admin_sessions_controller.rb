class AdminSessionsController < ApplicationController
  def new
  end

  def create
    @admin = Admin.find_by(username: params[:username])

    if @admin&.authenticate(params[:password])
      session.delete(:teacher_id)
      session.delete(:student_id)
      session[:admin_id] = @admin.id

      redirect_to root_path,
                  notice: "Welcome, #{@admin.username}!"
    else
      flash.now[:alert] = "Invalid username or password."

      render :new,
             status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin_id)

    redirect_to root_path,
                notice: "You have been logged out."
  end
end
