class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.references :professional, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end