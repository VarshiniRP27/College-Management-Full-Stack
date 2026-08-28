Rails.application.routes.draw do

  # =========================
  # Home
  # =========================

  root "home#index"

  get "home/about",
      to: "home#about",
      as: :home_about


  # =========================
  # Students
  # =========================

  resources :students

  get "students/statistics",
      to: "students#statistics",
      as: :student_statistics

  get "find",
      to: "students#find",
      as: :find_student


  # =========================
  # Teachers
  # =========================

  resources :teachers


  # =========================
  # Enrollments
  # =========================

  resources :enrollments


  # =========================
  # Admin Login
  # =========================

  get "admin/login",
      to: "admin_sessions#new",
      as: :admin_login

  post "admin/login",
       to: "admin_sessions#create"

  delete "admin/logout",
         to: "admin_sessions#destroy",
         as: :admin_logout


  # =========================
  # Rails Health Check
  # =========================

  get "up" => "rails/health#show",
      as: :rails_health_check

end