class TeachersController < ApplicationController

  before_action :require_admin,
                except: [:index, :show]

  before_action :set_teacher,
                only: [:show, :edit, :update, :destroy]


  # GET /teachers
  def index
    @teachers = Teacher
                 .includes(:courses)
                 .order(name: :asc)
  end


  # GET /teachers/1
  def show
    @courses = @teacher.courses
  end


  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end


  # POST /teachers
  def create
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      redirect_to @teacher,
                  notice: "Teacher was successfully created."
    else
      render :new,
             status: :unprocessable_entity
    end
  end


  # GET /teachers/1/edit
  def edit
  end


  # PATCH/PUT /teachers/1
  def update
    if @teacher.update(teacher_params)
      redirect_to @teacher,
                  notice: "Teacher was successfully updated."
    else
      render :edit,
             status: :unprocessable_entity
    end
  end


  # DELETE /teachers/1
  def destroy
    if @teacher.destroy
      redirect_to teachers_path,
                  notice: "Teacher was successfully deleted."
    else
      redirect_to teachers_path,
                  alert: @teacher.errors.full_messages.to_sentence
    end
  end


  private


  def set_teacher
    @teacher = Teacher.find(params[:id])
  end


  def teacher_params
    params.require(:teacher).permit(
      :name,
      :email
    )
  end

end