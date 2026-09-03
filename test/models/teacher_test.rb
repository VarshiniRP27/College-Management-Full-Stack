require "test_helper"

class TeacherTest < ActiveSupport::TestCase
  test "valid teacher" do
    teacher = Teacher.new(
      name: "Test Teacher",
      email: "teacher-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert teacher.valid?
  end

  test "requires name" do
    teacher = Teacher.new(
      email: "teacher-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not teacher.valid?
    assert_includes teacher.errors[:name], "can't be blank"
  end

  test "requires email" do
    teacher = Teacher.new(
      name: "Test Teacher",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not teacher.valid?
    assert_includes teacher.errors[:email], "can't be blank"
  end

  test "requires unique email" do
    email = "teacher-#{SecureRandom.hex(4)}@example.com"

    Teacher.create!(
      name: "First Teacher",
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )

    duplicate = Teacher.new(
      name: "Second Teacher",
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not duplicate.valid?
    assert duplicate.errors[:email].any?
  end

  test "has many courses" do
    association = Teacher.reflect_on_association(:courses)

    assert_equal :has_many, association.macro
  end
end
