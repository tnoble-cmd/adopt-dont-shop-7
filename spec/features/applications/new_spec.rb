# 2. Starting an Application

# As a visitor
# When I visit the pet index page
# Then I see a link to "Start an Application"
# When I click this link
# Then I am taken to the new application page where I see a form
# When I fill in this form with my:
#   - Name
#   - Street Address
#   - City
#   - State
#   - Zip Code
#   - Description of why I would make a good home
# And I click submit
# Then I am taken to the new application's show page
# And I see my Name, address information, and description of why I would make a good home
# And I see an indicator that this application is "In Progress"

require "rails_helper"

RSpec.describe "User Story 2 - Starting an Application", type: :feature do 
  describe "When I visit the pet index page" do
    before(:each) do
      @shelter_1 = Shelter.create!(name: "Get Me Outta Here", foster_program: true, city: "Denver", rank: 12)
      @shelter_2 = Shelter.create!(name: "Glue Factory Adoption Center", foster_program: true, city: "Boulder", rank: 2)
      
      @pet_1 = @shelter_1.pets.create!(name: "Bicho", breed: "Shug", age: 2, adoptable: true)
      @pet_2 = @shelter_1.pets.create!(name: "Appa", breed: "Catdog", age: 7, adoptable: true)
      @pet_3 = @shelter_2.pets.create!(name: "Qira", breed: "German Shephard", age: 2, adoptable: true)
      @pet_4 = @shelter_2.pets.create!(name: "Auzzie", breed: "Shitzu", age: 4, adoptable: false)
    end


    it "shows a link to 'Start an Application" do
      visit "/pets"
      expect(page).to have_link("Start an Application", href: "/applications/new")
    end

    it "takes me to the new application page when I click the 'Start an Application' link" do 
      visit "/pets"
      click_link "Start an Application"
      expect(page).to have_current_path("/applications/new")
    end

    it "shows fillable forms on the 'New Application' page for each field" do 
      visit "/applications/new"
      
      expect(page).to have_selector("form")
      expect(page).to have_field("Applicant name")
      expect(page).to have_field("Street address")
      expect(page).to have_field("City")
      expect(page).to have_field("State")
      expect(page).to have_field("Zip")
      expect(page).to have_field("Description")
    end
    
    describe "applicant submission process" do 
      it "has a 'Submit' button that saves the form info and redirects me to the new application show page" do 
        visit "/applications/new"

        expect(page).to have_button("Submit")
        
        fill_in :applicant_name, with: "Lito"
        fill_in :street_address, with: "1234 Main St."
        fill_in :city, with: "Denver"
        fill_in :state, with: "CO"
        fill_in :zip, with: "80202"
        fill_in :description, with: "I am a good dog man, yes?"

        click_button "Submit"
        
        application = Application.last

        #show page
        expect(page).to have_current_path("/applications/#{application.id}")

        expect(page).to have_content("Lito")
        expect(page).to have_content("1234 Main St.")
        expect(page).to have_content("Denver")
        expect(page).to have_content("CO")
        expect(page).to have_content("80202")
        expect(page).to have_content("I am a good dog man, yes?")

        expect(page).to have_content("Status: In Progress")
      end
    end
  end
end