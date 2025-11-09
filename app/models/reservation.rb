class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # バリデーション
  validates :check_in, :check_out, :guests, presence: true
  validates :guests, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate :check_in_cannot_be_in_the_past
  validate :check_out_must_be_after_check_in

  # 宿泊日数を計算するメソッド
  def nights
    return 0 unless check_in && check_out
    (check_out - check_in).to_i
  end

  # 宿泊料金を計算するメソッド
  def calculate_total_price
    return 0 unless room && nights.positive?
    room.price.to_i * nights * guests.to_i
  end

  private

  # チェックイン日が過去でないことを確認する
  def check_in_cannot_be_in_the_past
    return unless check_in.present?
    errors.add(:check_in, "は本日以降を指定してください") if check_in < Date.current
  end

  # チェックアウト日がチェックイン日より後であることを確認する
  def check_out_must_be_after_check_in
    return unless check_in.present? && check_out.present?
    errors.add(:check_out, "はチェックイン日より後の日付を指定してください") if check_out <= check_in
  end
end
