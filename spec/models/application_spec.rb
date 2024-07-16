require "rails_helper"

RSpec.describe Application, type: :model do 
  it { should have_many(:pets) }
  it { should have_many(:pet_applications) }
  
  describe "validations" do
    it "validates successful validation" do 
      application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "CO", zip: "80303", description: "I is the goodest.")
      #will set status to "In Progress" if not set when User creates new application(saved)
      application.save

      expect(application).to be_valid
    end
    
    it "is invalid without an applicant name" do 
      application = Application.new(applicant_name: "", street_address: "1234 Main St.", city: "Denver", state: "CO", zip: "80303", description: "I is the goodest.")
      
      expect(application).to_not be_valid
      expect(application.errors.full_messages).to include("Applicant name can't be blank")
    end

    it "is invalid without a street address" do 
      application = Application.new(applicant_name: "Lito", street_address: "", city: "Denver", state: "CO", zip: "80303", description: "I is the goodest.")

      expect(application).to_not be_valid
      expect(application.errors.full_messages).to include("Street address can't be blank")
    end
    
    it "is invalid without a city" do 
      application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "", state: "CO", zip: "80303", description: "I is the goodest.")
      
      expect(application).to_not be_valid
      expect(application.errors.full_messages).to include("City can't be blank")
    end
    
    it "is invalid without a state" do 
      application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "", zip: "80303", description: "I is the goodest.")
      
      expect(application).to_not be_valid
      expect(application.errors.full_messages).to include("State can't be blank")
    end
    
    it "is invalid without a zip" do 
      application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "CO", zip: "", description: "I is the goodest.")
      
      expect(application).to_not be_valid
      expect(application.errors.full_messages).to include("Zip can't be blank")
    end

    it "is not a zip without a number" do 
      application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "", zip: "A", description: "afdsafdsa")
      
      expect(application).to_not be_valid
      expect(application.errors.full_messages).to include("Zip is not a number")
    end
    
    it "is invalid without a description" do 
      application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "", zip: "80303", description: "")
      
      expect(application).to_not be_valid
      expect(application.errors.full_messages).to include("Description can't be blank")
    end
    
    it "creates all new applications with a status of 'In Progress'" do
      application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "NM", zip: "80303", description: "fdsaf")
      application.save
      
      expect(application.status).to eq("In Progress")
    end

  end
  
  describe "full_address" do 
    it "it concatenates all address elements and returns one string of all info" do
      application = Application.new(applicant_name: "Lito", street_address: "1234 Main St.", city: "Denver", state: "NM", zip: "80303", description: "description lol")
      
      expect(application.full_address).to eq("1234 Main St., Denver, NM 80303")
    end
  end
end

