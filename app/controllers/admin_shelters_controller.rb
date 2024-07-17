class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.all
    @shelter_applications = Shelter.shelters_with_pending_apps
  end
end