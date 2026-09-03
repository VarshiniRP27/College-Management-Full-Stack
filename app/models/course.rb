class Course < ApplicationRecord
  belongs_to :teacher

  has_many :students,
           dependent: :nullify

  has_many :enrollments,
           dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: true
end
