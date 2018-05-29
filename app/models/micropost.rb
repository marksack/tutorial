class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :picture

  default_scope -> { order(created_at: :desc) }

  validates_presence_of :user

  validates_presence_of :content
  validates :content, length: { maximum: 140 }

  validate :picture_is_image_type

  private

    def picture_is_image_type
      errors.add(:picture, 'must be an image file.') if
        picture.attached? &&
        !picture.content_type.in?(%w[image/jpeg image/gif image/png image/svg+xml])
    end

    def picture_is_not_too_big
      errors.add(:picture, 'must be smaller than 5MB') if picture.byte_size > 5.megabytes
    end
end
