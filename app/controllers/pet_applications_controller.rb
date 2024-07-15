class PetApplicationsController < ApplicationController

  def create
    #creates a many to many relationship between pets and applications on the pet_applications joins table, then redirects to the application show page.
    @application = Application.find(params[:application_id])
    @pet = Pet.find(params[:pet_id])
    PetApplication.create(application_id: @application.id, pet_id: @pet.id)
    redirect_to "/applications/#{params[:application_id]}"
  end

  private
  #strong params
  def pet_application_params
    params.permit(
      :pet_id,
      :application_id
    )
  end
end
