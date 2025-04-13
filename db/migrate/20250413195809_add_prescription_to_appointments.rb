class AddPrescriptionToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :prescription, :text
  end
end
