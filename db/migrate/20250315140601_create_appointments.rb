class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments, id: :uuid do |t|
      t.references :patient, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.references :professional, type: :uuid, null: false, foreign_key: true
      t.references :clinic, type: :uuid, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.string :status
      t.timestamps
    end
  end
end