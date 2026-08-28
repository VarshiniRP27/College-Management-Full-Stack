class Student < ApplicationRecord

  belongs_to :course, optional: true

  has_many :enrollments,
           dependent: :destroy

  validates :name,
            presence: true

  validates :age,
            presence: true

  validates :marks,
            presence: true

  # Calculate student result from marks
  def result
    if marks.present? && marks >= 40
      "PASS"
    else
      "FAIL"
    end
  end

end