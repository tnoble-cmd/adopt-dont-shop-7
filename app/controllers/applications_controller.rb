class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.pets
  end

  def index
    @application = Application.find(params[:application_id])
    if params[:search]
      @pets = Pet.where("name ILIKE ?", "%#{params[:search]}%")
    elsif params[:pet_id]
      pet = Pet.find(params[:pet_id])
      @application.pets << pet
      redirect_to "/applications/#{@application.id}"
    end
  end

  def new
  end

  def create
    @application = Application.new(application_params)
    @application.set_default_status
    # save means validations were met
    if @application.save
      redirect_to "/applications/#{Application.last.id}"
    else
    redirect_to "/applications/new"
    flash[:error] = @application.errors.full_messages.join(", ")
    end
  end

  private
  def application_params
    params.permit(
      :applicant_name,
      :street_address,
      :city,
      :state,
      :zip,
      :description
    )
  end
end
