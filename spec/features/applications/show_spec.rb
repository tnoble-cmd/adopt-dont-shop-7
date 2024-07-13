# 1. Application Show Page

# As a visitor
# When I visit an applications show page
# Then I can see the following:
# - Name of the Applicant
# - Full Address of the Applicant including street address, city, state, and zip code
# - Description of why the applicant says they'd be a good home for this pet(s)
# - names of all pets that this application is for (all names of pets should be links to their show page)
# - The Application's status, either "In Progress", "Pending", "Accepted", or "Rejected"

require "rails_helper"

RSpec.describe "User Story #1 - Application Show Page", type: :feature do
  describe "When I visit the show page" do
    before :each do
      @application_1 = Application.create!(name: "Tyler Noble", address: "123 Main St", city: "Denver", state: "CO", zip: "80202", description: "I basically AM a dog.", status: "In Progress")
      @application_2 = Application.create!(name: "Lito Croy", address: "456 Elm St", city: "Albuquerque", state: "NM", zip: "87108", description: "Me like dogs mucho.", status: "Pending")
      
      # Pets created via shelters because a pet belongs_to a shelter
      @pet_1 = @shelter_1.pets.create!(name: "Bicho", breed: "Shug", age: 2, adoptable: true)
      @pet_2 = @shelter_1.pets.create!(name: "Appa", breed: "Catdog", age: 7, adoptable: true)
      @pet_3 = @shelter_2.pets.create!(name: "Qira", breed: "German Shephard", age: 2, adoptable: true)
      @pet_4 = @shelter_2.pets.create!(name: "Auzzie", breed: "Shitzu", age: 4, adoptable: false)
      
      @shelter_1 = Shelter.create!(name: "Get Me Outta Here", address: "1234 Colfax Ave", city: "Denver", state: "CO", zip: "80204")
      @shelter_2 = Shelter.create!(name: "Boulder Valley Humane Society", address: "2323 55th St", city: "Boulder", state: "CO", zip: "80301")

      # We definitely need these for the 3rd `it` block test, right?
      # This is our JOINED table that includes records showing multiple Pet AND Application objects `have_many` PetApplications
      PetApplication.create!(pet: @pet_1, application: @application_1)
      PetApplication.create!(pet: @pet_2, application: @application_1)
      PetApplication.create!(pet: @pet_2, application: @application_2)
      PetApplication.create!(pet: @pet_3, application: @application_1)
      PetApplication.create!(pet: @pet_3, application: @application_2)
      PetApplication.create!(pet: @pet_4, application: @application_2)
      
      visit "/application/#{application.id}"
    end

    it "shows the full name of the applicant" do
      expect(page).to have_content("Name: #{@application_1.name}")
    end
    
    it "shows the reason for desired adoption" do
      expect(page).to have_content("Description: #{@application_1.description}")
    end
    
    it "shows the names of all pets selected for adoption" do
    # - names of all pets that this application is for (all names of pets should be links to their show page)
    # If we visit application_1, we would be expecting links to pet_1, pet_2, and pet_3
    # If we visit application_1, we would be expecting links to pet_2, pet_3, and pet_4 (how do we do that?)
    # 
      # We're expecting the page to `have_content` containing pet objects
      # We're expecting each page `has_link` to each pet object it contains
      expect("#{application.pets}").to include(pet)
      expect(page).to has_link()
      # has_link
    end
    
    it "shows the applicant's current application status" do
      expect(page).to have_content("Status: #{@application_1.status}")
    end
  end
end