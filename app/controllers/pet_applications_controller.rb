class PetApplicationsController < ApplicationController
  # def show
  #   #can search a pet from the application's show page (case insensitive)
  #   @application = Application.find(params[:id])
  #   @search = Pet.where("name ILIKE ?", "%#{params[:name]}%")
  # end

  def create
    @application = Application.find(params[:application_id])
    @pet = Pet.find(params[:pet_id])
    @application.pets << @pet
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
