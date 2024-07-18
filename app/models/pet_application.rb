class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def default_status
    self.status = "Pending"
  end

  def approve
    update(status: "Approved")
  end

  def reject
    update(status: "Rejected")
  end
end