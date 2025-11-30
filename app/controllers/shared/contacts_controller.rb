class Shared::ContactsController < ApplicationController
  before_action :set_contact
  def edit
  end

  def update
    respond_to do |format|
      if @contact.update(contact_params)
        flash.now[:notice] = "Contact was successfully updated."
        format.html { redirect_back(fallback_location: @contact, notice: "Contact was successfully updated.") }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @contact.errors, status: :unprocessable_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Shared::Contact.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.expect(shared_contact: [ :primary_email, :primary_phone_number, :secondary_phone_number, :secondary_email ])
  end
end
