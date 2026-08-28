class Enrollment < ApplicationRecord

  belongs_to :student

  belongs_to :course

  validates :enrolled_at,
            presence: true

  validates :status,
            presence: true

  validates :student_id,
            uniqueness: {
              scope: :course_id,
              message: "is already enrolled in this course"
            }

end