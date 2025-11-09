class User < ApplicationRecord
  has_one_attached :icon
  has_many :reservations, dependent: :destroy
  has_many :rooms, through: :reservations
  has_many :owned_rooms, class_name: "Room", foreign_key: "user_id", dependent: :destroy
  has_secure_password
  # 必須項目のバリデーション
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
