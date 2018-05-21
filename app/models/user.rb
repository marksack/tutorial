class User < ApplicationRecord
  validates_presence_of :name
  validates :name, length: { maximum: 50 }

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  before_save { email.downcase! }

  validates_presence_of :password
  validates :password, length: { minimum: 6 }
  has_secure_password
end
