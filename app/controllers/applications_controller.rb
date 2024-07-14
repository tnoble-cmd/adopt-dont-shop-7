class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.pets
  end

  def new
  end

  def create
    @application = Application.new(application_params)

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
    ).merge(status: "In Progress")
  end
end
