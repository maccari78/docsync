class RemoveNameFromUsersAgain < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :name, :string if column_exists?(:users, :name)
  end
end