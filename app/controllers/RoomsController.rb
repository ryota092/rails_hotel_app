class RoomsController < ApplicationController
  before_action :set_room, only: [ :show, :edit, :update, :destroy ]
  before_action :require_login # もしログイン必須のヘルパー名が違えば置き換えてください
  before_action :authorize_owner!, only: [ :edit, :update, :destroy ]

  # 自分が作成した施設一覧
  def index
    @rooms = current_user.owned_rooms.order(created_at: :desc)
  end

  # 施設の詳細表示
  def show
    # 詳細は set_room で取得
  end

  # 施設の新規作成フォーム表示
  def new
    @room = current_user ? current_user.owned_rooms.new : Room.new
  end

  # 施設の作成保存
  def create
    @room = current_user.owned_rooms.new(room_params)
    if @room.save
      redirect_to @room, notice: "施設を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 編集フォーム表示
  def edit
  end

  # 施設の更新
  def update
    if @room.update(room_params)
      redirect_to @room, notice: "施設を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 施設の削除
  def destroy
    @room.destroy
    redirect_to rooms_path, notice: "施設を削除しました"
  end

  # 検索（エリア検索 + フリーワード）
  def search
    q = params[:q].to_s.strip
    area = params[:area].to_s.strip

    @rooms = Room.all
    # エリアは指定の４つ
    allowed_areas = [ "東京", "大阪", "京都", "札幌" ]
    if area.present? && allowed_areas.include?(area)
      escaped = ActiveRecord::Base.sanitize_sql_like(area)
      @rooms = @rooms.where("LOWER(address) LIKE LOWER(?)", "%#{escaped}%")
    end

    if q.present?
      escaped = ActiveRecord::Base.sanitize_sql_like(q)
      @rooms = @rooms.where("LOWER(name) LIKE LOWER(:kw) OR LOWER(description) LIKE LOWER(:kw)", kw: "%#{escaped}%")
    end

    @rooms = @rooms.order(created_at: :desc)
    @count = @rooms.count
  end

  private
  # ログイン必須のヘルパー
  def require_login
    unless current_user
      redirect_to new_session_path, alert: "ログインが必要です"
    end
  end

  # 施設を取得するヘルパー
  def set_room
    @room = Room.find(params[:id])
  end

  # オーナー権限を確認するヘルパー
  def authorize_owner!
    unless @room.user_id == current_user.id
      redirect_to rooms_path, alert: "権限がありません"
    end
  end

  # ストロングパラメーター
  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end
