class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations, id: :uuid, if_not_exists: true do |t|
      t.references :appointment, null: false, foreign_key: true, type: :uuid
      t.references :sender, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :receiver, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.timestamps
    end
    add_index :conversations, :appointment_id, unique: true, if_not_exists: true
  end
end