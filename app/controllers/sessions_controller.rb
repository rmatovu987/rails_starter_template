class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  layout "auth", only: %i[ new create ]

  def new
    redirect_to root_path if current_user
  end

  def create
    if (user = User.authenticate_by(params.permit(:email_address, :password)))
      if (user.sessions.empty? && user.last_password_change_at.nil?) || user.last_password_change_at < AuthConfig::EXPIRY_PASSWORD_AFTER.ago
        terminate_session
        reset_session
        redirect_to edit_password_url(user.password_reset_token), notice: "Welcome #{user.firstname}, please set a new password!"
      else
        start_new_session_for user
        session[:user_id] = user.id

        # Calculate the actual expiry date of the password
        password_expiry_date = user.last_password_change_at + AuthConfig::EXPIRY_PASSWORD_AFTER

        # Calculate the date one week from now
        one_week_from_now = Time.current + 1.week

        # Check if the password expiry date is within the next week (i.e., less than a week away)
        # and also ensure the password has not already expired.
        if password_expiry_date < one_week_from_now && password_expiry_date > Time.current
          flash.now[:alert] = "Your password is about to expire. Please change it soon."
        end

        redirect_to after_authentication_url
      end
    else
      redirect_to new_session_path, alert: "Try another email addresses or password."
    end
  end

  def destroy
    terminate_session
    reset_session

    redirect_to new_session_path, notice: "Logged out successfully.", status: :see_other, data: { turbo: false }
  end
end
