class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def full_address
    "#{street_address}, #{city}, #{state} #{zip}"
  end

  def pets_selected
    pet_applications.where("application_id = application.id")
  end
end

