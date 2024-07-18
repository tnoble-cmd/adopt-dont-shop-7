require "rails_helper"

RSpec.describe PetApplication, type: :model do 
  describe "relationships" do 
    it { should belong_to :pet }
    it { should belong_to :application }
  end

  describe "instance methods" do
    it "#default_status" do
      pet_application = PetApplication.new
      pet_application.default_status
      expect(pet_application.status).to eq("Pending")
    end

    it "#approve" do
      pet_application = PetApplication.new
      pet_application.approve
      expect(pet_application.status).to eq("Approved")
    end

    it "#reject" do
      pet_application = PetApplication.new
      pet_application.reject
      expect(pet_application.status).to eq("Rejected")
    end
  end
end
