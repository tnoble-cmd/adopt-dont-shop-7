require "rails_helper"

RSpec.describe Application, type: :model do 
  it { should have_many(:pets) }
  it { should have_many(:pet_applications) }
  
  # Update tests to use shoulda-matchers

  describe "validations" do
    it { should validate_presence_of(:applicant_name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:zip) }
    it { should validate_numericality_of(:zip) }

    describe "default status" do
      it "sets the default status to 'In Progress' if not provided" do
        application = Application.create(
          applicant_name: "Lito",
          street_address: "1234 Main St.",
          city: "Denver",
          state: "CO",
          zip: "80303",
          description: "I is the goodest."
        )
        expect(application.status).to eq('In Progress')
      end
    end

    describe "valid application" do
      it "is valid with all required attributes" do
        application = Application.new(
          applicant_name: "Lito",
          street_address: "1234 Main St.",
          city: "Denver",
          state: "CO",
          zip: "80303",
          description: "I is the goodest."
        )
  
        expect(application).to be_valid
      end
    end
  end
  
  describe "full_address" do 
    it "it concatenates all address elements and returns one string of all info" do
      application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "NM", zip: "80303", description: "description lol")
      
      expect(application.full_address).to eq("1234 Main St., Denver, NM 80303")
    end
  end

  describe "no_display_form" do 
    it "returns true if status is 'In Progress'" do 
      application = Application.create!(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "NM", zip: "80303", description: "description lol")
      
      expect(application.no_display_form).to eq(true)
    end
  end

  describe "no_display_form_pets" do 
    it "returns false if status is 'In Progress' == true and there are no pets (meaning it will not render form)" do 
      application = Application.create!(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "NM", zip: "80303", description: "description lol")
      
      expect(application.status).to eq("In Progress")
      expect(application.pets).to eq([])
      expect(application.no_display_form_pets).to eq(false)
    end
    
### IS THIS TEST BELOW NEEDED IF I HAVE THE ONES STARTING ON LINE 85?

    # it "creates all new applications with a status of 'In Progress'" do
    #   application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "NM", zip: "80303", description: "fdsaf")
    #   application.save
      
    #   expect(application.status).to eq("In Progress")
    # end

    describe "set_status_pending" do
      it "sets the status to 'Pending'" do
        application = Application.create!(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "NM", zip: "80303", description: "description lol")
        application.set_status_pending
        expect(application.status).to eq("Pending")
      end
    end

    it "returns true if status is 'In Progress' == true and there are pets (meaning it will render form)" do 
      application = Application.create!(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "NM", zip: "80303", description: "description lol")
      shelter = Shelter.create!(name: "Get Me Outta Here", foster_program: true, city: "Denver", rank: 12)
      pet = shelter.pets.create!(name: "Bicho", breed: "Shug", age: 2, adoptable: true)
      application.pets << pet
      
      expect(application.status).to eq("In Progress")
      expect(application.pets).to eq([pet])
      expect(application.no_display_form_pets).to eq(true)
    end
  end

  # TESTS PASS!
  describe "changing application status" do
    it "creates new application with a status of 'In Progress' as default" do
      application = Application.create!(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "CO", zip: "80303", description: "I is the goodest.")

      application.set_default_status
      expect(application.status).to eq("In Progress")
    end

    it "updates application status to 'Pending' upon adding pets & clicking button 'Submit Application' " do
      application = Application.create!(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "CO", zip: "80303", description: "I is the goodest.")

      application.set_default_status

      expect(application.status).to eq("In Progress")

      application.set_status_pending

      expect(application.status).to eq("Pending")
    end
  end
end

