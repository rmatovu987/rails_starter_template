class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy attach_branch detach_branch
   assign_role revoke_role add_role add_branch generate_user_token upload_photo edit_photo clear_photo ]

  # Add my_profile, change_password, update_password to before_action for current_user context
  before_action :set_current_user_for_profile_actions, only: %i[
    my_profile change_password update_password my_profile
  ]

  # GET /settings/organization/users or /settings/organization/users.json
  def index
    authorize! NodeNames::USERS, PermissionNames::VIEW_ALL
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "Organization", url: nil },
      { name: "Users", url: users_path }
    ]
    @users = User.includes(:avatar_attachment, :assigned_branch).all
  end

  # GET /settings/organization/users/1 or /settings/organization/users/1.json
  def show
    authorize! NodeNames::USERS, PermissionNames::VIEW_DETAILS
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "Organization", url: nil },
      { name: "Users", url: users_path },
      { name: "#{@user.firstname} #{@user.lastname}", url: user_path(@user) }
    ]
    @versions = dependent_versions(@user,
                                   *@user&.user_roles,
                                   *@user&.user_branches,
                                   @user&.contact,
                                   @user&.address)
  end

  # GET /settings/organization/users/new
  def new
    authorize! NodeNames::USERS, PermissionNames::CREATE
    @user = User.new
  end

  # GET /settings/organization/users/1/edit
  def edit
    authorize! NodeNames::USERS, PermissionNames::UPDATE
  end

  # POST /settings/organization/users or /settings/organization/users.json
  def create
    authorize! NodeNames::USERS, PermissionNames::CREATE
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /settings/organization/users/1 or /settings/organization/users/1.json
  def update
    authorize! NodeNames::USERS, PermissionNames::UPDATE
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_back fallback_location: @user, notice: "Update was successful." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /settings/organization/users/1 or /settings/organization/users/1.json
  def destroy
    authorize! NodeNames::USERS, PermissionNames::DELETE
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other,
                                notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_role
    authorize! NodeNames::USERS, PermissionNames::ASSIGN_ROLE
  end

  def assign_role
    authorize! NodeNames::USERS, PermissionNames::ASSIGN_ROLE
    role = Role.find(params["user"]["role_id"])
    if @user.roles.include?(role)
      respond_to do |format|
        format.html { redirect_to @user, alert: "User already has this role." }
        format.json { render json: { error: "User already has this role." }, status: :unprocessable_content }
      end
    else
      @user.roles << role
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: "User was successfully assigned role." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_content }
          format.json { render json: @user.errors, status: :unprocessable_content }
        end
      end
    end
  end

  def revoke_role
    authorize! NodeNames::USERS, PermissionNames::REVOKE_ROLE
    role = Role.find(params[:role_id])
    @user.roles.delete(role)
    respond_to do |format|
      if @user.save # Save is needed after deleting from association
        format.html { redirect_to @user, notice: "User role was successfully revoked." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  def add_branch
    authorize! NodeNames::USERS, PermissionNames::ATTACH_BRANCH_TO_USER
  end

  def attach_branch
    authorize! NodeNames::USERS, PermissionNames::ATTACH_BRANCH_TO_USER
    branch = Branch.find(params["user"]["branch_id"])
    if @user.branches.include?(branch)
      respond_to do |format|
        format.html { redirect_to @user, alert: "User already has this branch attached." }
        format.json { render json: { error: "User already has this branch attached." }, status: :unprocessable_content }
      end
    else
      @user.branches << branch
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: "Branch successfully attached to user" }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_content }
          format.json { render json: @user.errors, status: :unprocessable_content }
        end
      end
    end
  end

  def detach_branch
    authorize! NodeNames::USERS, PermissionNames::DETACH_BRANCH_FROM_USER
    branch = Branch.find(params[:branch_id])
    @user.branches.delete(branch)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "Branch successfully detached to user" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  def generate_user_token
    authorize! NodeNames::USERS, PermissionNames::GENERATE_USER_TOKEN
    respond_to do |format|
      if current_user.id == @user.id
        token = ApiAuthentication.encode_token(@user)
        format.html { redirect_to my_profile_users_path(token: token),
                                  notice: "User token generated successfully." }
        format.json { render json: { token: token }, status: :ok }
      else
        format.html { redirect_to @user, alert: "You can not generate a token for another user!" }
        format.json { render json: [ "You can not generate a token for another user!" ], status: :unprocessable_content }
      end
    end
  end

  def my_profile
    @token = params[:token]
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "My Profile", url: my_profile_users_path }
    ]
    @versions = dependent_versions(@user,
                                   *@user&.user_roles,
                                   *@user&.user_branches,
                                   @user&.contact,
                                   @user&.address)
  end

  # GET /settings/organization/users/change_password
  def change_password;end

  # PATCH/PUT /settings/organization/users/update_password
  def update_password
    respond_to do |format|
      if @user.update(password_change_params)
        terminate_session
        reset_session

        flash[:notice] = "Password updated successfully. Please log in again."
        format.html { redirect_to my_profile_users_path(@user), notice: "Password updated successfully." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :change_password, status: :unprocessable_content } # Re-render the form with errors
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  def edit_photo; end

  def upload_photo
    respond_to do |format|
      if current_user.id == @user.id
        @user.avatar.attach(user_params[:avatar])
        if @user.valid? && @user.save
          metadata = @user.avatar.attached? ? {
            filename: @user.avatar.filename.to_s,
            content_type: @user.avatar.content_type,
            byte_size: @user.avatar.byte_size,
            blob_id: @user.avatar.blob_id
          } : nil

          PaperTrail::Version.create!(
            item_type: @user.class.name,
            item_id: @user.id,
            event: "attach_profile",
            whodunnit: PaperTrail.request.whodunnit,
            object: PaperTrail.serializer.dump(@user.attributes),
            object_changes: PaperTrail.serializer.dump({ "avatar" => metadata }),
            created_at: Time.current
          )

          format.html { redirect_back fallback_location: @user, notice: "Photo updated successfully." }
          format.json { render :show, status: :ok }
        else
          format.html { render :edit_photo, status: :unprocessable_content }
          format.json { render json: @user.errors, status: :unprocessable_content }
        end
      else
        flash[:alert] = "You can not upload a photo for another user!"
        format.html { render :edit_photo, status: :unprocessable_content }
        format.json { render json: [ "You can not upload a photo for another user!" ], status: :unprocessable_content }
      end
    end
  end

  def clear_photo
    respond_to do |format|
      if current_user.id == @user.id
        @user.avatar.purge
        if @user.save
          PaperTrail::Version.create!(
            item_type: @user.class.name,
            item_id: @user.id,
            event: "detach_profile",
            whodunnit: PaperTrail.request.whodunnit,
            object: PaperTrail.serializer.dump(@user.attributes),
            object_changes: PaperTrail.serializer.dump({ "avatar" => nil }),
            created_at: Time.current
          )

          format.html { redirect_back fallback_location: @user, notice: "Profile picture deleted!" }
          format.json { render :show, status: :ok }
        else
          format.html { redirect_back fallback_location: @user, status: :unprocessable_content }
          format.json { render json: @user.errors, status: :unprocessable_content }
        end
      else
        format.html { redirect_back fallback_location: @user, status: :unprocessable_content }
        format.json { render json: [ "You can not upload a photo for another user!" ], status: :unprocessable_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params.expect(:id))
  end

  # Sets @user to current_user for profile-related actions.
  # This prevents users from accessing/modifying other users' profiles via URL manipulation.
  def set_current_user_for_profile_actions
    @user = current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.expect(user: [ :firstname, :lastname, :email, :time_zone, :avatar ])
  end

  # Strong parameters specifically for password change.
  def password_change_params
    params.require(:user).permit(
      :current_password,
      :password, # This is the new password
      :password_confirmation # This is the new password confirmation
    )
  end
end
