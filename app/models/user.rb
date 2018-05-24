class User < ApplicationRecord
  attr_accessor :remember_token
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

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token_param)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token_param)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
