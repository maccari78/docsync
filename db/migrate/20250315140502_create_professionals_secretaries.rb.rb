class CreateProfessionalsSecretaries < ActiveRecord::Migration[7.1]
  def change
    create_table :professionals_secretaries do |t|
      t.references :professional, null: false, foreign_key: true
      t.references :secretary, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end