class Settings::BranchesController < ApplicationController
  before_action :set_settings_branch, only: %i[ show edit update destroy ]

  # GET /settings/branches or /settings/branches.json
  def index
    @settings_branches = Settings::Branch.all
  end

  # GET /settings/branches/1 or /settings/branches/1.json
  def show
  end

  # GET /settings/branches/new
  def new
    @settings_branch = Settings::Branch.new
  end

  # GET /settings/branches/1/edit
  def edit
  end

  # POST /settings/branches or /settings/branches.json
  def create
    @settings_branch = Settings::Branch.new(settings_branch_params)

    respond_to do |format|
      if @settings_branch.save
        format.html { redirect_to @settings_branch, notice: "Branch was successfully created." }
        format.json { render :show, status: :created, location: @settings_branch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @settings_branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/branches/1 or /settings/branches/1.json
  def update
    respond_to do |format|
      if @settings_branch.update(settings_branch_params)
        format.html { redirect_to @settings_branch, notice: "Branch was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @settings_branch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @settings_branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/branches/1 or /settings/branches/1.json
  def destroy
    @settings_branch.destroy!

    respond_to do |format|
      format.html { redirect_to settings_branches_path, notice: "Branch was successfully destroyed.", status: :see_other }
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
      params.expect(settings_branch: [ :name, :encoded_key, :unique_id, :isMain, :status, :business_id ])
    end
end
