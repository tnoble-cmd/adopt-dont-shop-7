class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :applicant_name
      t.string :full_address
      t.string :description
      t.string :status

      t.timestamps
    end
  end
end
