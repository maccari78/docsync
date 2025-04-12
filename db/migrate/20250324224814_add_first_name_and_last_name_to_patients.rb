class AddFirstNameAndLastNameToPatients < ActiveRecord::Migration[7.1]
  def change
    add_column :patients, :first_name, :string
    add_column :patients, :last_name, :string
    # Opcional: eliminar la columna name si ya no la necesitas
    remove_column :patients, :name, :string
  end
end