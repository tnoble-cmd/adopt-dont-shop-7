require 'rails_helper'

RSpec.describe AdminShelters, type: :model do 
  
  it "lists shelter names in reverse alphabetical order" do 
    shelter_1 = Shelter.create!(name: "Get Me Outta Here", foster_program: true, city: "Denver", rank: 12)
    shelter_2 = Shelter.create!(name: "Glue Factory Adoption Center", foster_program: true, city: "Boulder", rank: 2)
    shelter_3 = Shelter.create!(name: "Lost Friends Shelter", foster_program: true, city: "Chicago", rank: 5)

    admin_shelters = Shelter.query_shelters

    expect(admin_shelters.query_shelters).to eq(["Get Me Outta Here", "Glue Factory Adoption Center", "Lost Friends Shelter"])
  end
end