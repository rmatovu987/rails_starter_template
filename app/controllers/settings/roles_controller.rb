class Settings::RolesController < ApplicationController
  before_action :set_settings_role, only: %i[ show edit update destroy update_permission]

  # GET /settings/organization/roles or /settings/organization/roles.json
  def index
    authorize! NodeNames::ROLES, PermissionNames::VIEW_ALL
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "Roles", url: settings_roles_path }
    ]
    @settings_roles = Settings::Role.all
  end

  # GET /settings/organization/roles/1 or /settings/organization/roles/1.json
  def show
    authorize! NodeNames::ROLES, PermissionNames::VIEW_DETAILS
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "Organization", url: nil },
      { name: "Roles", url: settings_roles_path },
      { name: @settings_role.name, url: settings_role_path(@settings_role) }
    ]
    @settings_system_permission_nodes = System::PermissionNode.roots

    @versions = dependent_versions(@settings_role, *@settings_role.role_permissions)
  end

  # GET /settings/organization/roles/new
  def new
    authorize! NodeNames::ROLES, PermissionNames::CREATE
    @settings_role = Settings::Role.new
  end

  # GET /settings/organization/roles/1/edit
  def edit
    authorize! NodeNames::ROLES, PermissionNames::UPDATE
  end

  # POST /settings/organization/roles or /settings/organization/roles.json
  def create
    authorize! NodeNames::ROLES, PermissionNames::CREATE

    name = settings_role_params["name"]
    description = settings_role_params["description"]
    @settings_role = Settings::CreateRole.new.call(name, description, current_user.business)

    respond_to do |format|
      if @settings_role.persisted?
        format.html { redirect_to @settings_role, notice: "Role was successfully created." }
        format.json { render :show, status: :created, location: @settings_role }
      else
        flash.now[:error] = @settings_role.errors.full_messages.to_sentence
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @settings_role.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /settings/organization/roles/1 or /settings/organization/roles/1.json
  def update
    authorize! NodeNames::ROLES, PermissionNames::UPDATE
    respond_to do |format|
      if @settings_role.update(settings_role_params)
        flash.now[:notice] = "Role was successfully updated."
        format.html { redirect_to @settings_role, notice: "Role was successfully updated." }
        format.json { render :show, status: :ok, location: @settings_role }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @settings_role.errors, status: :unprocessable_content }
      end
    end
  end

  def update_permission
    authorize! NodeNames::ROLES, PermissionNames::UPDATE_PERMISSIONS
    role_permission = System::RolePermission.find(params[:id])
    respond_to do |format|
      role_permission.can_access = !role_permission.can_access

      # Collect parent RolePermissions to update if access is granted
      parents_to_update = []
      if role_permission.can_access
        node = role_permission.permission_node
        while node&.parent
          perm = System::RolePermission.find_or_initialize_by(
            role: role_permission.role,
            permission_node: node.parent,
            business: role_permission.business # Assuming business association
          )
          unless perm.can_access
            perm.can_access = true
            parents_to_update << perm
          end
          node = node.parent
        end
      end

      ActiveRecord::Base.transaction do
        role_permission.save!
        parents_to_update.each(&:save!)
      end

      format.html do
        redirect_to settings_role_path(role_permission.role),
                    notice: "Permissions updated successfully."
      end
      format.json { render :show, status: :ok, location: role_permission.role }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to settings_roles_path, alert: "Permission not found." }
      format.json { render json: { error: "Permission not found" }, status: :not_found }
    end
  end

  # DELETE /settings/organization/roles/1 or /settings/organization/roles/1.json
  def destroy
    authorize! NodeNames::ROLES, PermissionNames::DELETE
    @settings_role.destroy!

    respond_to do |format|
      format.html { redirect_to settings_roles_path, status: :see_other, notice: "Role was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_settings_role
      @settings_role = Settings::Role.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def settings_role_params
      params.expect(settings_role: [ :name, :description ])
    end
end
