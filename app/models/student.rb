class Student < ApplicationRecord
  belongs_to :course, optional: true

  has_many :enrollments, dependent: :destroy

  has_secure_password

  validates :name,
            presence: true

  validates :email,
            presence: true,
            uniqueness: true

  validates :age,
            presence: true,
            numericality: { greater_than: 0 }

  validates :marks,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }

  def result
    marks.present? && marks >= 40 ? "PASS" : "FAIL"
  end
end
