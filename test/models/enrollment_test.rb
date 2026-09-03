require "test_helper"

class EnrollmentTest < ActiveSupport::TestCase
  def create_teacher
    Teacher.create!(
      name: "Teacher #{SecureRandom.hex(4)}",
      email: "teacher-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  def create_student
    Student.create!(
      name: "Student #{SecureRandom.hex(4)}",
      email: "student-#{SecureRandom.hex(4)}@example.com",
      age: 20,
      marks: 80,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  def create_course
    Course.create!(
      name: "Course #{SecureRandom.hex(4)}",
      description: "Test course",
      teacher: create_teacher
    )
  end

  test "valid enrollment" do
    student = create_student
    course = create_course

    enrollment = Enrollment.new(
      student: student,
      course: course,
      enrolled_at: Time.current,
      status: "active"
    )

    assert enrollment.valid?
  end

  test "requires enrolled_at" do
    enrollment = Enrollment.new(
      student: create_student,
      course: create_course,
      status: "active"
    )

    assert_not enrollment.valid?
    assert enrollment.errors[:enrolled_at].any?
  end

  test "requires status" do
    enrollment = Enrollment.new(
      student: create_student,
      course: create_course,
      enrolled_at: Time.current
    )

    assert_not enrollment.valid?
    assert enrollment.errors[:status].any?
  end

  test "prevents duplicate student enrollment in same course" do
    student = create_student
    course = create_course

    Enrollment.create!(
      student: student,
      course: course,
      enrolled_at: Time.current,
      status: "active"
    )

    duplicate = Enrollment.new(
      student: student,
      course: course,
      enrolled_at: Time.current,
      status: "active"
    )

    assert_not duplicate.valid?
    assert duplicate.errors[:student_id].any?
  end

  test "belongs to student" do
    association = Enrollment.reflect_on_association(:student)

    assert_equal :belongs_to, association.macro
  end

  test "belongs to course" do
    association = Enrollment.reflect_on_association(:course)

    assert_equal :belongs_to, association.macro
  end
end
