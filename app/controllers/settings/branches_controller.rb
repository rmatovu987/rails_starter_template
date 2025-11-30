class Settings::BranchesController < ApplicationController
  before_action :set_settings_branch, only: %i[ show edit update destroy activate close ]

  # GET /settings/organization/branches or /settings/organization/branches.json
  def index
    authorize! NodeNames::BRANCHES, PermissionNames::VIEW_ALL
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "Branches", url: settings_branches_path }
    ]
    @settings_branches = Settings::Branch.all
  end

  # GET /settings/organization/branches/1 or /settings/organization/branches/1.json
  def show
    authorize! NodeNames::BRANCHES, PermissionNames::VIEW_DETAILS
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "Branches", url: settings_branches_path },
      { name: @settings_branch.name, url: settings_branch_path(@settings_branch) }
    ]
    @versions = dependent_versions(@settings_branch)
  end

  # GET /settings/organization/branches/new
  def new
    authorize! NodeNames::BRANCHES, PermissionNames::CREATE
    @settings_branch = Settings::Branch.new
  end

  # GET /settings/organization/branches/1/edit
  def edit
    authorize! NodeNames::BRANCHES, PermissionNames::UPDATE
  end

  # POST /settings/organization/branches or /settings/organization/branches.json
  def create
    authorize! NodeNames::BRANCHES, PermissionNames::CREATE
    @settings_branch = Settings::Branch.new(settings_branch_params)
    @settings_branch.address = Shared::Address.new(business_id: current_user.business_id)
    @settings_branch.contact = Shared::Contact.new(business_id: current_user.business_id)

    respond_to do |format|
      if @settings_branch.save
        format.html { redirect_to @settings_branch, notice: "Branch was successfully created." }
        format.json { render :show, status: :created, location: @settings_branch }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @settings_branch.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /settings/organization/branches/1 or /settings/organization/branches/1.json
  def update
    authorize! NodeNames::BRANCHES, PermissionNames::UPDATE
    respond_to do |format|
      if @settings_branch.update(settings_branch_params)
        format.html { redirect_to @settings_branch, notice: "Branch was successfully updated." }
        format.json { render :show, status: :ok, location: @settings_branch }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @settings_branch.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /settings/organization/branches/1 or /settings/organization/branches/1.json
  def destroy
    authorize! NodeNames::BRANCHES, PermissionNames::DELETE
    @settings_branch.destroy!

    respond_to do |format|
      format.html { redirect_to settings_branches_path, status: :see_other, notice: "Branch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def activate
    authorize! NodeNames::BRANCHES, PermissionNames::ACTIVATE
    @settings_branch.Active!

    respond_to do |format|
      format.html { redirect_to @settings_branch, status: :see_other, notice: "Branch was successfully activated." }
      format.json { head :no_content }
    end
  end

  def close
    authorize! NodeNames::BRANCHES, PermissionNames::CLOSE
    @settings_branch.Closed!

    respond_to do |format|
      format.html { redirect_to @settings_branch, status: :see_other, notice: "Branch was successfully closed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_settings_branch
    @settings_branch = Settings::Branch.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def settings_branch_params
    params.expect(settings_branch: [ :name, :code, :isMain, :assigned_branch_id ])
  end
end
