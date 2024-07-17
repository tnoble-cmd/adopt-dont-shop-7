require "rails_helper"


RSpec.describe "Admin & Application Approval/Rejection", type: :feature do 
  before :each do
    @application_1 = Application.create!(applicant_name: "Tyler Noble", street_address: "123 Main St", city: "Denver", state: "CO", zip: "80202", description: "I basically AM a dog.", status: "In Progress")
    @application_2 = Application.create!(applicant_name: "Lito Croy", street_address: "456 Elm St", city: "Albuquerque", state: "NM", zip: "87108", description: "Me like dogs mucho.", status: "Pending")
    @application_3 = Application.create!(applicant_name: "Gary Busey", street_address: "666 Elm St", city: "Detroit", state: "MI", zip: "20983", description: "Turtles call me daddy.", status: "Pending")
    
    @shelter_1 = Shelter.create!(name: "Get Me Outta Here", foster_program: true, city: "Denver", rank: 12)
    @shelter_2 = Shelter.create!(name: "Glue Factory Adoption Center", foster_program: true, city: "Boulder", rank: 2)
    @shelter_3 = Shelter.create!(name: "Lost Friends Shelter", foster_program: true, city: "Chicago", rank: 5)
    
    @pet_1 = @shelter_1.pets.create!(name: "Bicho", breed: "Shug", age: 2, adoptable: true)
    @pet_2 = @shelter_1.pets.create!(name: "Appa", breed: "Catdog", age: 7, adoptable: true)
    @pet_3 = @shelter_2.pets.create!(name: "Qira", breed: "German Shephard", age: 2, adoptable: true)
    @pet_4 = @shelter_2.pets.create!(name: "Auzzie", breed: "Shitzu", age: 4, adoptable: false)
    @pet_5 = @shelter_2.pets.create!(name: "August", breed: "Cerebus", age: 3489, adoptable: true)
    
    # Am I correctly creating relationships with applications here?
    # I need to reach from shelters > pets > pet_applications > applications
    PetApplication.create!(pet: @pet_1, application: @application_1)
    PetApplication.create!(pet: @pet_2, application: @application_1)
    PetApplication.create!(pet: @pet_3, application: @application_1)
    
    PetApplication.create!(pet: @pet_2, application: @application_2)
    PetApplication.create!(pet: @pet_3, application: @application_2)
    PetApplication.create!(pet: @pet_4, application: @application_2)
  
    PetApplication.create!(pet: @pet_3, application: @application_3)
    PetApplication.create!(pet: @pet_4, application: @application_3)
    PetApplication.create!(pet: @pet_5, application: @application_3)
  end
  
    
  describe "User Story #10 - SQL Only Story" do
      it "lists shelter names in reverse alphabetical order" do

        visit "/admin/shelters"

        # Do I place this method elsewhere and call it here?
        sql_query = Shelter.find_by_sql("SELECT name FROM shelters ORDER BY name DESC")
        # expect(sql_query).to eq(["Get Me Outta Here", "Glue Factory Adoption Center", "Lost Friends Shelter"])
        
        expect(page).to have_content("Get Me Outta Here")
        expect(page).to have_content("Glue Factory Adoption Center")
        expect(page).to have_content("Lost Friends Shelter")
        
        # Same here if necessary
        expect("Lost Friends Shelter").to appear_before("Glue Factory Adoption Center")
        expect("Glue Factory Adoption Center").to appear_before("Get Me Outta Here")
      end
    end
  
  # Will need to update Shelter/Application Models to create association
  describe "User Story #11 - Shelters with Pending Applications" do
    xit "I see a section listing all shelter names with pending applications" do
      

      # Do we need to visit the page to utilize an AR query?
      visit "/admin/shelters"
      
      expect(@shelters_with_pending_apps.name).to eq(["Glue Factory Adoption Center", "Lost Friends Shelter"])
    end
  end
end

