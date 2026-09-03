require "test_helper"

class CourseTest < ActiveSupport::TestCase
  def create_teacher
    Teacher.create!(
      name: "Test Teacher #{SecureRandom.hex(4)}",
      email: "teacher-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "valid course" do
    teacher = create_teacher

    course = Course.new(
      name: "Test Course #{SecureRandom.hex(4)}",
      description: "Test description",
      teacher: teacher
    )

    assert course.valid?
  end

  test "requires name" do
    teacher = create_teacher

    course = Course.new(
      description: "Test description",
      teacher: teacher
    )

    assert_not course.valid?
    assert_includes course.errors[:name], "can't be blank"
  end

  test "requires unique name" do
    teacher = create_teacher

    Course.create!(
      name: "Unique Test Course #{SecureRandom.hex(4)}",
      description: "First course",
      teacher: teacher
    )

    duplicate_name = Course.last.name

    duplicate = Course.new(
      name: duplicate_name,
      description: "Second course",
      teacher: teacher
    )

    assert_not duplicate.valid?
    assert duplicate.errors[:name].any?
  end

  test "belongs to teacher" do
    association = Course.reflect_on_association(:teacher)

    assert_equal :belongs_to, association.macro
  end

  test "has many students" do
    association = Course.reflect_on_association(:students)

    assert_equal :has_many, association.macro
  end

  test "has many enrollments" do
    association = Course.reflect_on_association(:enrollments)

    assert_equal :has_many, association.macro
  end
end
