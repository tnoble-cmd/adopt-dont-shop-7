require 'rails_helper'

RSpec.feature 'Applications (search) index page' do 
  before :each do
    @application_1 = Application.create!(applicant_name: "Tyler Noble", street_address: "123 Main St", city: "Denver", state: "CO", zip: "80202", description: "I basically AM a dog.", status: "In Progress")
    @application_2 = Application.create!(applicant_name: "Lito Croy", street_address: "456 Elm St", city: "Albuquerque", state: "NM", zip: "87108", description: "Me like dogs mucho.", status: "In Progress")
    @application_3 = Application.create!(applicant_name: "Gary Busey", street_address: "666 Elm St", city: "Detroit", state: "MI", zip: "20983", description: "Turtles call me daddy.", status: "In Progress")
    
    
    @shelter_1 = Shelter.create!(name: "Get Me Outta Here", foster_program: true, city: "Denver", rank: 12)
    @shelter_2 = Shelter.create!(name: "Glue Factory Adoption Center", foster_program: true, city: "Boulder", rank: 2)
    
    # Pets created via shelters because a pet belongs_to a shelter
    @pet_1 = @shelter_1.pets.create!(name: "Bicho", breed: "Shug", age: 2, adoptable: true)
    @pet_2 = @shelter_1.pets.create!(name: "Appa", breed: "Catdog", age: 7, adoptable: true)
    @pet_3 = @shelter_2.pets.create!(name: "Qira", breed: "German Shephard", age: 2, adoptable: true)
    @pet_4 = @shelter_2.pets.create!(name: "Auzzie", breed: "Shitzu", age: 4, adoptable: false)
    
    
    # We definitely need these for the 3rd `it` block test, right?
    # This is our JOINED table that includes records showing multiple Pet AND Application objects `have_many` PetApplications
    PetApplication.create!(pet: @pet_1, application: @application_1)
    PetApplication.create!(pet: @pet_2, application: @application_1)
    PetApplication.create!(pet: @pet_3, application: @application_1)
    
    PetApplication.create!(pet: @pet_2, application: @application_2)
    PetApplication.create!(pet: @pet_3, application: @application_2)
    PetApplication.create!(pet: @pet_4, application: @application_2)
  end

  describe "When I search for a pet" do 
    it "I see a list of pets that match my search" do 
      visit "/applications/#{@application_1.id}"

      fill_in "search", with: "Bicho"
      click_button "Submit"

      expect(page).to have_content(@pet_1.name)

      expect(page).to have_button("Add Pet")
    end

    it "I can add a pet to my application" do 
      visit "/applications/#{@application_1.id}"

      fill_in "search", with: "Qira"
      click_button "Submit"

      expect(page).to have_content(@pet_3.name)

      expect(page).to have_button("Add Pet")

      click_button "Add Pet"

      expect(current_path).to eq("/applications/#{@application_1.id}")
      expect(page).to have_content(@pet_3.name)
    end

    it "types a pet that is not in the Pets Table" do
      visit "/applications/#{@application_1.id}"
      
      fill_in "search", with: "Gojira"
      click_button "Submit"
      
      expect(page).to_not have_content(@pet_1.name)
      expect(page).to_not have_content(@pet_2.name)
      expect(page).to_not have_content(@pet_3.name)
      expect(page).to_not have_content(@pet_4.name)
      
      expect(page).to_not have_button("Add Pet")
      expect(current_path).to eq("/applications")

      expect(page).to_not have_content(@pet_1.name)
      expect(page).to_not have_content(@pet_2.name)
      expect(page).to_not have_content(@pet_3.name)
      expect(page).to_not have_content(@pet_4.name)
    end


    it "shows all pets if 'Submit' is hit and search field is blank" do
        visit "/applications/#{@application_3.id}"
        
        @application_1.reload
        expect(page).to_not have_content(@pet_1.name)
        expect(page).to_not have_content(@pet_2.name)
        expect(page).to_not have_content(@pet_3.name)
        expect(page).to_not have_content(@pet_4.name)

        click_button "Submit"
        expect(current_path).to eq("/applications")

        expect(page).to have_content(@pet_1.name)
        expect(page).to have_content(@pet_2.name)
        expect(page).to have_content(@pet_3.name)
        expect(page).to have_content(@pet_4.name)

        expect(page).to have_button("Add Pet")
    end

    it "shows a flash message if no pets are found" do
      visit "/applications/#{@application_1.id}"

      fill_in "search", with: "Gojira"
      click_button "Submit"

      expect(page).to have_content("No pets found with that name")
    end
  end
end