class ApplicationsController < ApplicationController
  def show
    #show an application and its pets after /applications/new is submitted
    @application = Application.find(params[:id])
    @pets = @application.pets
  end

  def index
    #search for a pet. Check if search is present, if so, search for the pet, if not, show all pets
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
    #goes to the new application page rendering the new application form for the user to create a new application.
  end

  def create
    # create a new application, set default status to "In Progress", save, if save is successful, redirect to the new application's show page. If not, redirect to the new application page and display error messages
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
  #strong params
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
