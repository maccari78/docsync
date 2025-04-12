class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.references :clinic, type: :uuid, null: true, foreign_key: true

      t.timestamps null: false

      t.integer :role, default: 0
      t.string :first_name
      t.string :last_name
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end