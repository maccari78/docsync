class CreateProfessionalsSecretaries < ActiveRecord::Migration[7.1]
  def change
    create_table :professionals_secretaries, id: :uuid do |t|
      t.references :professional, type: :uuid, null: false, foreign_key: true
      t.references :secretary, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end