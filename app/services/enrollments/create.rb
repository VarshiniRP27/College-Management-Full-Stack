module Enrollments
  class Create
    def self.call(student:, course:, enrolled_at:, status:)
      new(
        student: student,
        course: course,
        enrolled_at: enrolled_at,
        status: status
      ).call
    end

    def initialize(student:, course:, enrolled_at:, status:)
      @student = student
      @course = course
      @enrolled_at = enrolled_at
      @status = status
    end

    def call
      Enrollment.transaction do
        Enrollment.create!(
          student: @student,
          course: @course,
          enrolled_at: @enrolled_at,
          status: @status
        )
      end
    end
  end
end
