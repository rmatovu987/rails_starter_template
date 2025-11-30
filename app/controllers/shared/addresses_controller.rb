class Shared::AddressesController < ApplicationController
  before_action :set_address
  def edit
  end

  def update
    respond_to do |format|
      if @address.update(address_params)
        flash.now[:notice] = "Address was successfully updated."
        format.html { redirect_back(fallback_location: @address, notice: "Address was successfully updated.") }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @address.errors, status: :unprocessable_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_address
    @address = Shared::Address.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def address_params
    params.expect(shared_address: [ :street_name, :city, :region, :country ])
  end
end
