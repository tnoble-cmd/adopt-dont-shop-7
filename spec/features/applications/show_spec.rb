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
  before :each do
    @application_1 = Application.create!(applicant_name: "Tyler Noble", street_address: "123 Main St", city: "Denver", state: "CO", zip: "80202", description: "I basically AM a dog.", status: "In Progress")
    @application_2 = Application.create!(applicant_name: "Lito Croy", street_address: "456 Elm St", city: "Albuquerque", state: "NM", zip: "87108", description: "Me like dogs mucho.", status: "In Progress")
    
    
    @shelter_1 = Shelter.create!(name: "Get Me Outta Here", foster_program: true, city: "Denver", rank: 12)
    @shelter_2 = Shelter.create!(name: "Glue Factory Adoption Center", foster_program: true, city: "Boulder", rank: 2)
    
    # Pets created via shelters because a pet belongs_to a shelter
    @pet_1 = @shelter_1.pets.create!(name: "Bicho", breed: "Shug", age: 2, adoptable: true)
    @pet_2 = @shelter_1.pets.create!(name: "Appa", breed: "Catdog", age: 7, adoptable: true)
    @pet_3 = @shelter_2.pets.create!(name: "Qira", breed: "German Shephard", age: 2, adoptable: true)
    @pet_4 = @shelter_2.pets.create!(name: "Auzzie", breed: "Shitzu", age: 4, adoptable: false)
    
    
    # We definitely need these for the 3rd `it` block test, right?
    # This is our JOINED table that includes records showing multiple Pet AND Application objects `have_many` PetApplications
    
    # Did we create these pet_application objects correctly or were we supposed to use pet_id and application_id like we do in the PetApplicationsController?
    PetApplication.create!(pet: @pet_1, application: @application_1)
    PetApplication.create!(pet: @pet_2, application: @application_1)
    PetApplication.create!(pet: @pet_3, application: @application_1)
    
    PetApplication.create!(pet: @pet_2, application: @application_2)
    PetApplication.create!(pet: @pet_3, application: @application_2)
    PetApplication.create!(pet: @pet_4, application: @application_2)
    
    visit "/applications/#{@application_1.id}"
  end

  describe "When I visit the show page" do
    it "is on the correct page" do
      expect(page).to have_current_path("/applications/#{@application_1.id}")
    end

    it "shows the full name of the applicant" do
      expect(page).to have_content("Name: #{@application_1.applicant_name}")
    end
    
    it "shows the reason for desired adoption" do
      expect(page).to have_content("Description: #{@application_1.description}")
    end

    it "shows the full address of the applicant" do
      expect(page).to have_content("Address: #{@application_1.full_address}")
    end
    
    it "shows the applicant's current application status" do
      expect(page).to have_content("Application Status: #{@application_1.status}")
    end

    it "shows the names of all pets selected for adoption" do
      # - names of all pets that this application is for (all names of pets should be links to their show page)
      # If we visit application_1, we would be expecting links to pet_1, pet_2, and pet_3
      # If we visit application_1, we would be expecting links to pet_2, pet_3, and pet_4 (how do we do that?)

      # We're expecting the page to `have_content` containing pet objects
      # We're expecting each page `has_link` to each pet object it contains
      expect(page).to have_content(@application_1.pets.name)
      expect(page).to have_link(@pet_1.name, href: "/pets/#{@pet_1.id}")
      expect(page).to have_link(@pet_2.name, href: "/pets/#{@pet_2.id}")
      expect(page).to have_link(@pet_3.name, href: "/pets/#{@pet_3.id}")
    end
  end

  # 4. Searching for Pets for an Application

  # As a visitor
  # When I visit an application's show page
  # And that application has not been submitted,
  # Then I see a section on the page to "Add a Pet to this Application"
  # In that section I see an input where I can search for Pets by name
  # When I fill in this field with a Pet's name
  # And I click submit,
  # Then I am taken back to the application show page
  # And under the search bar I see any Pet whose name matches my search

  describe "User Story #4 - Searching for Pets" do
    it "can search for a pet from the application's show page" do

      visit "/applications/#{@application_1.id}"

      expect(page).to have_content("Add a Pet to this Application")
      expect(page).to have_field(:search)
      
      fill_in :search, with: @pet_1.name
      
      click_button "Submit"

      
      expect(current_path).to eq("/applications")
    end

    it "can search a pet with case insensitive text" do
      expect(page).to have_content("Add a Pet to this Application")
      expect(page).to have_field(:search)
      
      fill_in :search, with: @pet_1.name.upcase
      
      click_button "Submit"

      
      expect(current_path).to eq("/applications")
      expect(page).to have_content(@pet_1.name)
    end
  end
  
  # 5. Add a Pet to an Application
  
  ## As a visitor
  ## When I visit an application's show page
  ## And I search for a Pet by name
  ## And I see the names (of?) Pets that match my search
  ## Then next to each Pet's name I see a button to "Adopt this Pet"
  ## When I click one of these buttons
  ## Then I am taken back to the application show page
  
  # And I see the Pet I want to adopt listed on this application
    # How is this different from the last line in US#4?
      # Are we just adding the button to select it and that's all?
        # => That's what it seems like
  
  describe "User Story #5 - Add pet to Application" do 
    it "adds a searched pet to an application via 'Submit' button" do 
      ## And I search for a Pet by name
      fill_in :search, with: @pet_1.name
      
      click_button "Submit"
      
      #goes to search index page
      expect(current_path).to eq("/applications")

      ## Then next to each Pet's name I see a button to "Adopt this Pet"
      expect(page).to have_button("Add Pet")
      
      
      ## When I click on the first button, "Add Pet"
      first(:button, "Add Pet").click
      
      ## Then I am taken back to the application show page
      expect(page).to have_current_path("/applications/#{@application_1.id}")

      
      # checks if pet name is under the 'Desired Pets' section
      within('div', text: 'Desired Pets') do
        expect(page).to have_content(@pet_1.name)
      end
      
    end
  end

  # # 6. Submit an Application

  # As a visitor
  # When I visit an application's show page
  # And I have added one or more pets to the application
  # Then I see a section to submit my application
  # And in that section I see an input to enter why I would make a good owner for these pet(s)
  # When I fill in that input (Description section)
  # And I click a button to submit this application
  
  # Then I am taken back to the application's show page
  # And I see an indicator that the application is "Pending"
  # And I see all the pets that I want to adopt
  # And I do not see a section to add more pets to this application

  describe "User Story #6 - Application Submission" do
    it "shows a section to submit my application with 1 or more pet" do 
  
      fill_in :search, with: @pet_1.name
      click_button "Search" # Do we need to rename this button `Search`?  We might have two named 'Submit'.
      first(:button, "Add Pet").click

      expect(page).to have_field(:description)
      expect(page).to have_button("Submit")

      fill_in :description, with: "I love dogs."
      
      expect(page).to have_current_path("/applications/#{@application_1.id}")
      redirect_to "/applications/#{@application_1.id}"

      expect(@application_1.status).to eq("Pending")
      expect(page).to have_content(@pet_1.name)
      expect(page).to_not have_button("Add Pet")
    end
  end
end








