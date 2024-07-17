class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  # Not 100% about this but I think this is how we need to get to applications
  has_many :pet_applications, through: :pets
  has_many :applications, through: :pet_applications

  # Call this from the '/admin/shelters' View page
  def self.shelters_with_pending_apps
    joins(pets: :applications).where(applications: { status: 'Pending' }).distinct
  end

  def self.reverse_alphabetical_order
    find_by_sql("SELECT name FROM shelters ORDER BY name DESC").pluck(:name)
  end

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where("age >= ?", age_filter)
  end
end
