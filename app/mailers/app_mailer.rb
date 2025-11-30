class AppMailer < ApplicationMailer
  def reset_password(user)
    @user = user
    mail subject: "Reset your password", to: user.email_address
  end

  def send_invite(invitation)
    @invitation = invitation
    @expiry = "#{Settings::Invitation::EXPIRY_DAYS} days"
    mail subject: "Invitation to SenteFlow", to: @invitation.email_address
  end
end
