require "test_helper"

class EnrollmentsCreateTest < ActiveSupport::TestCase
  setup do
    @teacher = Teacher.create!(
      name: "Service Teacher #{SecureRandom.hex(4)}",
      email: "service-teacher-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    @student = Student.create!(
      name: "Service Student #{SecureRandom.hex(4)}",
      email: "service-student-#{SecureRandom.hex(4)}@example.com",
      age: 20,
      marks: 85,
      password: "password123",
      password_confirmation: "password123"
    )

    @course = Course.create!(
      name: "Service Course #{SecureRandom.hex(4)}",
      description: "Service test course",
      teacher: @teacher
    )
  end

  test "creates enrollment successfully" do
    assert_difference("Enrollment.count", 1) do
      enrollment = Enrollments::Create.call(
        student: @student,
        course: @course,
        enrolled_at: Time.current,
        status: "active"
      )

      assert_equal @student.id, enrollment.student_id
      assert_equal @course.id, enrollment.course_id
      assert_equal "active", enrollment.status
    end
  end

  test "rejects duplicate enrollment" do
    Enrollments::Create.call(
      student: @student,
      course: @course,
      enrolled_at: Time.current,
      status: "active"
    )

    assert_raises(ActiveRecord::RecordInvalid) do
      Enrollments::Create.call(
        student: @student,
        course: @course,
        enrolled_at: Time.current,
        status: "active"
      )
    end
  end
end
