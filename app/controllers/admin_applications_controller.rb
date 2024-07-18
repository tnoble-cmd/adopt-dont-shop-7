class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.pets
  end

  def update
    @application = Application.find(params[:id])
    @pet_application = @application.pet_applications.find_by(pet_id: params[:pet_id])
    
    if params[:approve]
      @pet_application.approve
    elsif params[:reject]
      @pet_application.reject
    end
    redirect_to "/admin/applications/#{@application.id}"
  end
end
#