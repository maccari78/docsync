class CreateProfessionals < ActiveRecord::Migration[7.1]
  def change
    create_table :professionals, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.integer :specialty, default: 0, null: false
      t.string :license_number
      t.references :clinic, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end