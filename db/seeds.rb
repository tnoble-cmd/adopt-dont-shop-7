# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)




PetApplication.destroy_all
Application.destroy_all
Pet.destroy_all
Shelter.destroy_all


application_1 = Application.create!(applicant_name: "Tyler Noble", street_address: "123 Main St", city: "Denver", state: "CO", zip: "80202", description: "I basically AM a dog.")
application_2 = Application.create!(applicant_name: "Lito Croy", street_address: "456 Elm St", city: "Albuquerque", state: "NM", zip: "87108", description: "Me like dogs mucho.")

shelter_1 = Shelter.create!(foster_program: true, name: "Get Me Outta Here Pet Shelter", city: "Denver", rank: 7)
shelter_2 = Shelter.create!(foster_program: false, name: "Glue Factory Adoption Center", city: "Boulder", rank: 13)

pet_1 = shelter_1.pets.create!(name: "Bicho", breed: "Shug", age: 2, adoptable: true)
pet_2 = shelter_1.pets.create!(name: "Appa", breed: "Catdog", age: 7, adoptable: true)
pet_3 = shelter_2.pets.create!(name: "Qira", breed: "German Shephard", age: 2, adoptable: true)
pet_4 = shelter_2.pets.create!(name: "Auzzie", breed: "Shitzu", age: 4, adoptable: false)

PetApplication.create!(pet: pet_1, application: application_1)
PetApplication.create!(pet: pet_2, application: application_1)
PetApplication.create!(pet: pet_2, application: application_2)
PetApplication.create!(pet: pet_3, application: application_1)
PetApplication.create!(pet: pet_3, application: application_2)
PetApplication.create!(pet: pet_4, application: application_2)

puts "Seed successful"
