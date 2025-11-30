class System::PermissionsController < ApplicationController
  before_action :set_system_permission, only: %i[ show edit update destroy ]

  # GET /settings/system/permissions or /settings/system/permissions.json
  def index
    authorize! NodeNames::PERMISSIONS, PermissionNames::VIEW_ALL
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "System", url: nil },
      { name: "Permissions", url: system_permissions_path }
    ]
    @system_permissions = System::Permission.all
  end

  # GET /settings/system/permissions/1 or /settings/system/permissions/1.json
  def show
    authorize! NodeNames::PERMISSIONS, PermissionNames::VIEW_DETAILS
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "System", url: nil },
      { name: "Permissions", url: system_permissions_path },
      { name: @system_permission.name, url: system_permission_path(@system_permission) }
    ]
    @versions = dependent_versions(@system_permission)
  end

  # GET /settings/system/permissions/new
  def new
    authorize! NodeNames::PERMISSIONS, PermissionNames::CREATE
    @system_permission = System::Permission.new
  end

  # GET /settings/system/permissions/1/edit
  def edit
    authorize! NodeNames::PERMISSIONS, PermissionNames::UPDATE
  end

  # POST /settings/system/permissions or /settings/system/permissions.json
  def create
    authorize! NodeNames::PERMISSIONS, PermissionNames::CREATE
    @system_permission = System::Permission.new(system_permission_params)

    respond_to do |format|
      if @system_permission.save
        format.html { redirect_to @system_permission, notice: "Permission was successfully created." }
        format.json { render :show, status: :created, location: @system_permission }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @system_permission.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /settings/system/permissions/1 or /settings/system/permissions/1.json
  def update
    authorize! NodeNames::PERMISSIONS, PermissionNames::UPDATE
    respond_to do |format|
      if @system_permission.update(system_permission_params)
        format.html { redirect_to @system_permission, notice: "Permission was successfully updated." }
        format.json { render :show, status: :ok, location: @system_permission }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @system_permission.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /settings/system/permissions/1 or /settings/system/permissions/1.json
  def destroy
    authorize! NodeNames::PERMISSIONS, PermissionNames::DELETE
    @system_permission.destroy!

    respond_to do |format|
      format.html { redirect_to system_permissions_path, status: :see_other, notice: "Permission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_permission
      @system_permission = System::Permission.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_permission_params
      params.expect(system_permission: [ :business_id, :name, :description, :unique_id, :encoded_key ])
    end
end
