class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  validates_presence_of :name
  validates :name, length: { maximum: 50 }

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  before_save :downcase_email

  before_create :create_activation_digest

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    activation_token = self.activation_token
    UserMailer.account_activation(self, activation_token).deliver_later
  end

  private

    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
