class System::BranchesController < ApplicationController
  before_action :set_system_branch, only: %i[ show edit update destroy ]

  # GET /system/branches or /system/branches.json
  def index
    @system_branches = System::Branch.all
  end

  # GET /system/branches/1 or /system/branches/1.json
  def show
  end

  # GET /system/branches/new
  def new
    @system_branch = System::Branch.new
  end

  # GET /system/branches/1/edit
  def edit
  end

  # POST /system/branches or /system/branches.json
  def create
    @system_branch = System::Branch.new(system_branch_params)

    respond_to do |format|
      if @system_branch.save
        format.html { redirect_to @system_branch, notice: "Branch was successfully created." }
        format.json { render :show, status: :created, location: @system_branch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system/branches/1 or /system/branches/1.json
  def update
    respond_to do |format|
      if @system_branch.update(system_branch_params)
        format.html { redirect_to @system_branch, notice: "Branch was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @system_branch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system/branches/1 or /system/branches/1.json
  def destroy
    @system_branch.destroy!

    respond_to do |format|
      format.html { redirect_to system_branches_path, notice: "Branch was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_branch
      @system_branch = System::Branch.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_branch_params
      params.expect(system_branch: [ :name, :encoded_key, :unique_id, :isMain, :status, :business_id ])
    end
end
