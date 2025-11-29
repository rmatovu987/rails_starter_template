class System::BusinessesController < ApplicationController
  before_action :set_system_business, only: %i[ show edit update destroy ]

  # GET /system/businesses or /system/businesses.json
  def index
    @system_businesses = System::Business.all
  end

  # GET /system/businesses/1 or /system/businesses/1.json
  def show
  end

  # GET /system/businesses/new
  def new
    @system_business = System::Business.new
  end

  # GET /system/businesses/1/edit
  def edit
  end

  # POST /system/businesses or /system/businesses.json
  def create
    @system_business = System::Business.new(system_business_params)

    respond_to do |format|
      if @system_business.save
        format.html { redirect_to @system_business, notice: "Business was successfully created." }
        format.json { render :show, status: :created, location: @system_business }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @system_business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system/businesses/1 or /system/businesses/1.json
  def update
    respond_to do |format|
      if @system_business.update(system_business_params)
        format.html { redirect_to @system_business, notice: "Business was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @system_business }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @system_business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system/businesses/1 or /system/businesses/1.json
  def destroy
    @system_business.destroy!

    respond_to do |format|
      format.html { redirect_to system_businesses_path, notice: "Business was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_business
      @system_business = System::Business.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_business_params
      params.expect(system_business: [ :name, :encoded_key, :unique_id, :time_format, :datetime_format ])
    end
end
