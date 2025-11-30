class Settings::InvitationsController < ApplicationController
  allow_unauthenticated_access(only: %i[accept_invitation])
  before_action :set_settings_invitation, only: %i[ show edit update destroy resend_invitation ]

  # GET /settings/organization/invitations or /settings/organization/invitations.json
  def index
    authorize! NodeNames::INVITATIONS, PermissionNames::VIEW_ALL
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "Organization", url: nil },
      { name: "Invitations", url: settings_invitations_path }
    ]
    @settings_invitations = Settings::Invitation.all
  end

  # GET /settings/organization/invitations/1 or /settings/organization/invitations/1.json
  def show
    authorize! NodeNames::INVITATIONS, PermissionNames::VIEW_DETAILS
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "Organization", url: nil },
      { name: "Invitations", url: settings_invitations_path },
      { name: "#{@settings_invitation.firstname} #{@settings_invitation.lastname}",
        url: settings_invitation_path(@settings_invitation) }
    ]
    @versions = dependent_versions(@settings_invitation)
  end

  # GET /settings/organization/invitations/new
  def new
    authorize! NodeNames::INVITATIONS, PermissionNames::CREATE
    @settings_invitation = Settings::Invitation.new
  end

  # GET /settings/organization/invitations/1/edit
  def edit
    authorize! NodeNames::INVITATIONS, PermissionNames::UPDATE
  end

  # POST /settings/organization/invitations or /settings/organization/invitations.json
  def create
    authorize! NodeNames::INVITATIONS, PermissionNames::CREATE
    @settings_invitation = Settings::Invitation.new(settings_invitation_params)
    @settings_invitation.inviter = current_user
    @settings_invitation.business_id = current_user.business_id

    respond_to do |format|
      if Settings::Invitation.exists?(email_address: @settings_invitation.email_address) || User.exists?(email_address: @settings_invitation.email_address)
        @settings_invitation.errors.add(:base, "This email address has already been invited.")
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @settings_invitation.errors, status: :unprocessable_content }
      elsif @settings_invitation.save
        AppMailer.send_invite(@settings_invitation).deliver_later
        format.html { redirect_to @settings_invitation, notice: "Invitation was successfully created." }
        format.json { render :show, status: :created, location: @settings_invitation }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @settings_invitation.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /settings/organization/invitations/1 or /settings/organization/invitations/1.json
  def update
    authorize! NodeNames::INVITATIONS, PermissionNames::UPDATE
    respond_to do |format|
      if @settings_invitation.update(settings_invitation_params)
        format.html { redirect_to @settings_invitation, notice: "Invitation was successfully updated." }
        format.json { render :show, status: :ok, location: @settings_invitation }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @settings_invitation.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /settings/organization/invitations/1 or /settings/organization/invitations/1.json
  def destroy
    authorize! NodeNames::INVITATIONS, PermissionNames::DELETE
    @settings_invitation.destroy!

    respond_to do |format|
      format.html { redirect_to settings_invitations_path, status: :see_other, notice: "Invitation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def resend_invitation
    authorize! NodeNames::INVITATIONS, PermissionNames::UPDATE
    @settings_invitation = Settings::Invitation.find(params[:id])
    respond_to do |format|
      if @settings_invitation.accepted?
        format.html { redirect_to @settings_invitation, alert: "Invitation has already been accepted." }
        format.json { render json: { error: "Invitation has already been accepted." }, status: :unprocessable_content }
      else
        AppMailer.send_invite(@settings_invitation).deliver_later
        format.html { redirect_to @settings_invitation, notice: "Invitation was successfully resent." }
        format.json { head :no_content }
      end
    end
  end

  def accept_invitation
    @settings_invitation = Settings::Invitation.find_by_token_for(:invitation, params[:token])

    if @settings_invitation.nil?
      redirect_to new_session_path, alert: "Invitation expired! Ask the sender to resend the invitation."
      return
    end

    if @settings_invitation.accepted?
      redirect_to new_session_path, alert: "Invitation has already been accepted."
      return
    end

    data = {
      email_address: @settings_invitation.email_address,
      firstname: @settings_invitation.firstname,
      lastname: @settings_invitation.lastname,
      password: @settings_invitation.obfuscated_id,
      time_zone: @settings_invitation.time_zone,
      password_confirmation: @settings_invitation.obfuscated_id,
      business_id: @settings_invitation.business_id,
      assigned_branch_id: @settings_invitation.assigned_branch_id
    }
    @user = User.create!(data).tap do |user|
      @settings_invitation.accepted_at = Time.current
      @settings_invitation.status = "accepted"
      @settings_invitation.save!

      user.contact = Shared::Contact.new(customizable_id: @settings_invitation.id,
                                         customizable_type: @settings_invitation.class.name,
                                         business_id: @settings_invitation.business_id)
      user.address = Shared::Address.new(customizable_id: @settings_invitation.id,
                                         customizable_type: @settings_invitation.class.name,
                                         business_id: @settings_invitation.business_id)
      user.save!
    end

    redirect_to edit_password_url(@user.password_reset_token), notice: "Invitation accepted. Please set your password."
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_session_path, alert: "Invitation link is invalid or has expired."
  rescue ActiveRecord::RecordNotFound
    redirect_to new_session_path, alert: "Invitation not found."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_settings_invitation
    @settings_invitation = Settings::Invitation.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def settings_invitation_params
    params.expect(settings_invitation: [ :firstname, :lastname, :email_address, :time_zone, :assigned_branch_id ])
  end
end
