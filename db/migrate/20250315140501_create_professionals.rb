class CreateProfessionals < ActiveRecord::Migration[7.1]
  def change
    create_table :professionals do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :specialty

      t.timestamps
    end
  end
end
