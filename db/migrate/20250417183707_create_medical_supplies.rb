class CreateMedicalSupplies < ActiveRecord::Migration[7.1]
  def change
    create_table :medical_supplies, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :name, null: false
      t.text :description
      t.integer :stock_quantity, null: false, default: 0
      t.integer :minimum_stock, null: false, default: 0
      t.uuid :clinic_id, null: false
      t.timestamps
      t.index [:clinic_id], name: "index_medical_supplies_on_clinic_id"
    end

    add_foreign_key :medical_supplies, :clinics
  end
end