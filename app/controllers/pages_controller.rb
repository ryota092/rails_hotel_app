class PagesController < ApplicationController
  def home
    # おすすめの施設を取得
    @recommended_rooms = Room.order(created_at: :desc).limit(6)
  end
end
