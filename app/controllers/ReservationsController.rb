class ReservationsController < ApplicationController
  before_action :require_login
  before_action :set_reservation, only: [ :show, :destroy ]

  # 自分が予約した施設一覧
  def index
    @reservations = current_user.reservations.includes(:room).order(created_at: :desc)
  end

  # 新規フォーム（room_id を受け取る）
  def new
    @room = Room.find_by(id: params[:room_id])
    @reservation = current_user.reservations.new(room: @room)
  end

  # 確認ページ（保存はしない）
  def confirm
    @reservation = current_user.reservations.new(reservation_params)
    @reservation.room = Room.find_by(id: reservation_params[:room_id])

    if @reservation.invalid?
      flash.now[:alert] = "入力に問題があります"
      @room = @reservation.room
      render :new, status: :unprocessable_entity
      return
    end

    @total = @reservation.calculate_total_price
  end

  # 保存
  def create
    @reservation = current_user.reservations.new(reservation_params)
    @reservation.room = Room.find_by(id: reservation_params[:room_id])
    @reservation.total_price = @reservation.calculate_total_price

    if @reservation.save
      redirect_to @reservation, notice: "予約が確定しました"
    else
      flash.now[:alert] = "保存に失敗しました"
      @room = @reservation.room
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  # 予約キャンセル
  def destroy
    @reservation.destroy
    redirect_to reservations_path, notice: "予約をキャンセルしました"
  end

  private

  # current_userの予約のみを取得
  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:room_id, :check_in, :check_out, :guests)
  end

  # ログイン必須
  def require_login
    unless current_user
      flash[:alert] = "ログインが必要です"
      redirect_to new_session_path
    end
  end
end
