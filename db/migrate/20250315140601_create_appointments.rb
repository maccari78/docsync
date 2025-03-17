class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.references :professional, null: false, foreign_key: true
      t.references :clinic, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.string :status
      t.timestamps
    end
  end
end