class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private
  # 現在ログインしているユーザーを返す
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ユーザーがログインしているかどうかを返す
  def logged_in?
    current_user.present?
  end

  # ログインが必要なアクションの前に呼び出す
  def require_login
    redirect_to root_path, alert: "ログインしてください" unless logged_in?
  end
end
