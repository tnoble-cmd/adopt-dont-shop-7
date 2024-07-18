# [ ] done

# 12. Approving a Pet for Adoption

# As a visitor
# When I visit an admin application show page ('/admin/applications/:id')
# For every pet that the application is for, I see a button to approve the 
  # application for that specific pet
# When I click that button
# Then I'm taken back to the admin application show page
# And next to the pet that I approved, I do not see a button to approve this pet
# And instead I see an indicator next to the pet that they have been approved

require "rails_helper"


RSpec.describe "Approval & Rejection of Pets for Adoption" do
  describe "When I visit 'admin/applications/:id' " do
    before :each do 
    @shelter = Shelter.create!(name: 'Denver Shelter', city: 'Denver, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter.pets.create!(name: 'Buddy', breed: 'Golden Retriever', age: 3, adoptable: true)
    @pet_2 = @shelter.pets.create!(name: 'Max', breed: 'Labrador', age: 2, adoptable: true)
    @application_1 = Application.create!(applicant_name: 'John Doe', street_address: '123 Main St', city: 'Denver', state: 'CO', zip: '80202', description: 'I love pets', status: 'Pending')
    @application_2 = Application.create!(applicant_name: 'Jane Doe', street_address: '123 Main St', city: 'Denver', state: 'CO', zip: '80202', description: 'I love pets', status: 'Pending')
    @application_3 = Application.create!(applicant_name: 'Jim Doe', street_address: '789 Oak St', city: 'Denver', state: 'CO', zip: '80204', description: 'I love pets', status: 'Pending')
    PetApplication.create!(pet: @pet_1, application: @application_1)
    PetApplication.create!(pet: @pet_2, application: @application_1)

    PetApplication.create!(pet: @pet_1, application: @application_2)
    PetApplication.create!(pet: @pet_2, application: @application_2)

    PetApplication.create!(pet: @pet_1, application: @application_3)
    PetApplication.create!(pet: @pet_2, application: @application_3)
      visit "/admin/applications/#{@application_1.id}"
    end

    describe "User Story #12 - Approving a Pet" do 
      # Happy Path - can't really figure out the Sad Path
      it "displays an approval button for every pet associated with that application" do 
        expect(page).to have_content(@pet_1.name)
        expect(page).to have_content(@pet_2.name)
        expect(page).to have_button("Approve")

        # Another Capybara way to click a specific button
        # We want it to click the first button matching "Approve"
        # When this is called, there should be 2 identical buttons
        # We want to click the first, get redirected (refresh page)
        # And then click the '2nd' button (the 1st should have disappeared)
        all(:button, "Approve")[0].click # Clicks 1st button (@pet_1)
        
        # Clicking "Approve" refreshes page
        expect(current_path).to eq("/admin/applications/#{@application_1.id}")
        
        all(:button, "Approve")[0].click # Clicks 2nd button (@pet_2)
        
        expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      end

      it "replaces pet approval buttons with status indicator for that specific pet" do
        expect(page).to have_content(@pet_1.name)
        expect(page).to have_button("Approve")

        all(:button, "Approve")[0].click
      
        expect(current_path).to eq("/admin/applications/#{@application_1.id}")

        # "Approve" button disappears
        expect(page).to have_content("Approved")
      end

      # 13. Rejecting a Pet for Adoption

      # As a visitor
      # When I visit an admin application show page ('/admin/applications/:id')
      # For every pet that the application is for, I see a button to reject the application for that specific pet
      # When I click that button
      # Then I'm taken back to the admin application show page
      # And next to the pet that I rejected, I do not see a button to approve or reject this pet
      # And instead I see an indicator next to the pet that they have been rejected

      describe "User Story #13 - Rejecting a Pet" do 
        it "displays a reject button for every pet associated with that application" do 
          expect(page).to have_content(@pet_1.name)
          expect(page).to have_content(@pet_2.name)
          expect(page).to have_button("Reject")

          all(:button, "Reject")[0].click
          
          expect(current_path).to eq("/admin/applications/#{@application_1.id}")
          
          all(:button, "Reject")[0].click
          
          expect(current_path).to eq("/admin/applications/#{@application_1.id}")
          
          expect(page).to have_content("Rejected")
          expect(page).to_not have_button("Reject")

        end

        it "replaces 'Approve'/'Reject' buttons with status indicator for that specific pet" do
          expect(page).to have_content(@pet_1.name)
          expect(page).to have_content(@pet_2.name)

          expect(page).to have_button("Reject")
          expect(page).to have_button("Approve")

          all(:button, "Reject")[0].click
          all(:button, "Approve")[0].click

          expect(current_path).to eq("/admin/applications/#{@application_1.id}")

          # "Reject" button disappears
          expect(page).to have_content("Rejected")
          # "Rejected" indicator appears instead
          expect(page).to_not have_button("Reject")

          #approve button disappears
          expect(page).to have_content("Approved")
          #approve indicator appears instead
          expect(page).to_not have_button("Approve")
        end
      end
    end

    
    # 14. Approved/Rejected Pets on one Application do not affect other Applications

    #   As a visitor
    #   When there are two applications in the system for the same pet
    #   When I visit the admin application show page for one of the applications
    #   And I approve or reject the pet for that application
    #   When I visit the other application's admin show page
    #   Then I do not see that the pet has been accepted or rejected for that application
    #   And instead I see buttons to approve or reject the pet for this specific application

    describe "User Story #14 - Approved/Rejected Pet Applications" do 
      it "does not affect other pet applications via approval/rejection of other pet applications" do 
        visit "/admin/applications/#{@application_2.id}"
        expect(page).to have_content(@pet_1.name)
        expect(page).to have_content(@pet_2.name)
        expect(page).to have_button("Reject")
        expect(page).to have_button("Approve")

        all(:button, "Reject")[0].click
        all(:button, "Reject")[0].click
        
        # The commonly desired pet is indicated to have been "Rejected" for this application
        expect(current_path).to eq("/admin/applications/#{@application_2.id}")
        expect(page).to have_content("Rejected")

        expect(page).to_not have_button("Reject")
        #--------------------------------------------------------------------------------
        # Navigate to other application with commonly desired pet

        visit "/admin/applications/#{@application_1.id}"
        
        # Commonly desired pet's status unaffected on different application
        # Both buttons present
        # NOT "Rejected"
        expect(current_path).to eq("/admin/applications/#{@application_1.id}")
        
        expect(page).to have_content(@pet_1.name)
        expect(page).to have_content(@pet_2.name)
        expect(page).to have_button("Reject")
        expect(page).to have_button("Approve")
        expect(page).to_not have_content("Rejected")
      end
    end
  end
end