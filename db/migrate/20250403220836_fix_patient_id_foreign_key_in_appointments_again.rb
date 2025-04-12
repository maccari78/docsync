class FixPatientIdForeignKeyInAppointmentsAgain < ActiveRecord::Migration[7.1]
  def up
    remove_foreign_key :appointments, :users, column: :patient_id, if_exists: true
    add_foreign_key :appointments, :patients, column: :patient_id
  end

  def down
    remove_foreign_key :appointments, :patients, column: :patient_id, if_exists: true
    add_foreign_key :appointments, :users, column: :patient_id
  end
end