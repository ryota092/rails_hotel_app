class SessionsController < ApplicationController
  # ログインフォームを表示
  def new
  end

  # メールでログイン処理
  def create
    user = User.find_by(email: params[:email].to_s.downcase)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to rooms_path, notice: "ログインしました。"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが違います"
      render :new
    end
  end

  def destroy
    # ログアウト処理
    session.delete(:user_id)
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
