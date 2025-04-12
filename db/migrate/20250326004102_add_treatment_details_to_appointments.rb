class AddTreatmentDetailsToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :treatment_details, :text
  end
end
