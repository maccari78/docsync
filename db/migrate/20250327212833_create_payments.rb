class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :appointment, type: :uuid, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :status, null: false, default: 0
      t.string :external_payment_id

      t.timestamps
    end
  end
end