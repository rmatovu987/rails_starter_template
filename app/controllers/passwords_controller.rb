class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  layout "auth", only: %i[ new create edit ]

  def new
  end

  def create
    if (user = User.find_by(email_address: params[:email_address]))
      AppMailer.reset_password(user).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email addresses exists)."
  end

  def edit
  end

  def update
    user_params = params.permit(:password, :password_confirmation).merge(last_password_change_at: Time.current)

    if @user.update(user_params)
      redirect_to new_session_path, notice: "Password has been reset."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      redirect_to edit_password_url(params[:token]), alert: @user.errors.full_messages.to_sentence
    end
  end

  private
  def set_user_by_token
    @user = User.find_by_password_reset_token!(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
  end
end
