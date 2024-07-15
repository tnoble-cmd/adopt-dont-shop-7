class PetApplicationsController < ApplicationController

  def create
    @application = Application.find(params[:application_id])
    @pet = Pet.find(params[:pet_id])
    PetApplication.create(application_id: @application, pet_id: @pet)
    redirect_to "/applications/#{params[:application_id]}"
  end

  private
  def pet_application_params
    params.permit(
      :pet_id,
      :application_id
    )
  end
end
