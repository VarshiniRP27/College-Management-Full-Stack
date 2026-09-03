Rails.application.routes.draw do
  root "home#index"
  get "home/about", to: "home#about", as: :home_about
  get "students/statistics", to: "students#statistics", as: :student_statistics
  get "find", to: "students#find", as: :find_student

  resources :students
  resources :courses

  get "teacher/register", to: "registrations#teacher_new", as: :teacher_register
  post "teacher/register", to: "registrations#teacher_create"

  get "student/register", to: "registrations#student_new", as: :student_register
  post "student/register", to: "registrations#student_create"

  get "teacher/login", to: "teacher_sessions#new", as: :teacher_login
  post "teacher/login", to: "teacher_sessions#create"
  delete "teacher/logout", to: "teacher_sessions#destroy", as: :teacher_logout
  get "teacher/dashboard", to: "teacher_dashboard#index", as: :teacher_dashboard

  resources :teachers

  get "student/login", to: "student_sessions#new", as: :student_login
  post "student/login", to: "student_sessions#create"
  delete "student/logout", to: "student_sessions#destroy", as: :student_logout
  get "student/dashboard", to: "student_dashboard#index", as: :student_dashboard

  resources :enrollments

  get "admin/login", to: "admin_sessions#new", as: :admin_login
  post "admin/login", to: "admin_sessions#create"
  delete "admin/logout", to: "admin_sessions#destroy", as: :admin_logout

  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"

      get "students/statistics", to: "students#statistics", as: :students_statistics
      resources :students

      resources :courses

      resources :enrollments, only: %i[index show create destroy]
    end
  end

  get "up", to: "rails/health#show", as: :rails_health_check
end
