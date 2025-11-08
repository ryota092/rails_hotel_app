# ...existing code...
class UsersController < ApplicationController
  before_action :require_login, only: [ :profile_edit, :profile_update, :account_edit, :account_update ]
  before_action :set_user, only: [ :show, :edit, :update, :profile_edit, :profile_update, :account_edit, :account_update ]

  # 新規登録フォーム表示
  def new
    @user = User.new
  end

  # 新規ユーザ登録
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "ユーザ登録が完了しました"
      redirect_to root_path
    else
      flash.now[:alert] = "ユーザ登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  # ユーザ編集
  def edit; end

  # ユーザ情報更新
  def update
    if @user.update(user_params)
      flash[:notice] = "アカウント情報を更新しました"
      redirect_to root_path
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  # プロフィール編集フォーム(ログイン時)
  def profile_edit; end

  # プロフィール更新（名前やアイコン）
  def profile_update
    if @user.update(profile_params)
      redirect_to root_path, notice: "プロフィールを更新しました"
    else
      render :profile_edit, status: :unprocessable_entity
    end
  end

  # アカウント編集フォーム（パスワードなど）
  def account_edit
    # 権限チェック、編集は自分のみ
    redirect_to root_path, alert: "権限がありません" unless @user == current_user
  end

  # アカウント更新
  def account_update
    unless @user == current_user
      redirect_to root_path, alert: "権限がありません" and return
    end

    ap = account_params.dup
    # パスワードが空なら更新対象から除外（空で送られた場合にパスワードを消さない）
    if ap[:password].blank?
      ap.delete(:password)
      ap.delete(:password_confirmation)
    end

    if @user.update(ap)
      redirect_to user_path(@user), notice: "アカウント情報を更新しました"
    else
      render :account_edit, status: :unprocessable_entity
    end
  end

  # Strong Parameters
  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :icon, :bio)
  end

  def profile_params
    params.require(:user).permit(:name, :icon, :bio)
  end

  def account_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
