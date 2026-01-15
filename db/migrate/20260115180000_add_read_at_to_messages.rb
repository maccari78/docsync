class AddReadAtToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :read_at, :datetime, null: true
    add_index :messages, :read_at
  end
end
