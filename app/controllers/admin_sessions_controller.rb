class AdminSessionsController < ApplicationController

  # GET /admin/login
  def new
  end

  # POST /admin/login
  def create
    @admin = Admin.find_by(username: params[:username])

    if @admin&.authenticate(params[:password])
      session[:admin_id] = @admin.id

      redirect_to students_path,
                  notice: "Welcome, #{@admin.username}!"
    else
      flash.now[:alert] = "Invalid username or password."
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /admin/logout
  def destroy
    session.delete(:admin_id)

    redirect_to root_path,
                notice: "You have been logged out."
  end

end