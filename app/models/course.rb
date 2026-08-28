class Course < ApplicationRecord

  belongs_to :teacher

  has_many :students,
           dependent: :restrict_with_error

  has_many :enrollments,
           dependent: :destroy

  validates :name,
            presence: true

  validates :teacher,
            presence: true


  validates :description,
           presence: true

end