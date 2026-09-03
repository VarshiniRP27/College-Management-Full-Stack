require "test_helper"

class EnrollmentConfirmationJobTest < ActiveJob::TestCase
  setup do
    @teacher = Teacher.create!(
      name: "Job Teacher #{SecureRandom.hex(4)}",
      email: "job-teacher-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    @student = Student.create!(
      name: "Job Student #{SecureRandom.hex(4)}",
      email: "job-student-#{SecureRandom.hex(4)}@example.com",
      age: 20,
      marks: 85,
      password: "password123",
      password_confirmation: "password123"
    )

    @course = Course.create!(
      name: "Job Course #{SecureRandom.hex(4)}",
      description: "Job test course",
      teacher: @teacher
    )

    @enrollment = Enrollment.create!(
      student: @student,
      course: @course,
      enrolled_at: Time.current,
      status: "active"
    )
  end

  test "job sends confirmation email" do
    assert_nothing_raised do
      EnrollmentConfirmationJob.perform_now(@enrollment.id)
    end
  end
end
