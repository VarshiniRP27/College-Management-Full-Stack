class ApiToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  validates :user_type, presence: true
  validates :user_id, presence: true
end
