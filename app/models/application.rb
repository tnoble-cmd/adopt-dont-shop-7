class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  before_save :set_default_status

  validates :applicant_name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true, numericality: true
  validates :description, presence: true


  def full_address
    "#{street_address}, #{city}, #{state} #{zip}"
  end

  def set_default_status
    if self.status.nil?
      self.status = "In Progress"
    end
  end
end

