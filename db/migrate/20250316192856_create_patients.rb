class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.references :professional, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
