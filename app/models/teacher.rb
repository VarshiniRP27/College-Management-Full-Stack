class Teacher < ApplicationRecord

  has_many :courses,
           dependent: :destroy

  validates :name,
            presence: true

  validates :email,
            presence: true,
            uniqueness: true

end