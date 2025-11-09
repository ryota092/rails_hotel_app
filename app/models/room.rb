class Room < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  # 必須項目のバリデーション
  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :price, presence: true,
  numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  has_many :reservations
  has_many :users, through: :reservations
end
