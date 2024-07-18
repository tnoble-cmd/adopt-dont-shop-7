class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def default_status
    self.status = "Pending"
  end

  def approve
    self.update(status: "Approved")
  end

  def reject
    self.update(status: "Rejected")
  end
end