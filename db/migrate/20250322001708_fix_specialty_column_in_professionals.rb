class FixSpecialtyColumnInProfessionals < ActiveRecord::Migration[7.1]
  def up
    # Primero, establecer todos los valores de specialty a 0 (dentist) si son nil
    execute <<-SQL
      UPDATE professionals SET specialty = '0' WHERE specialty IS NULL;
    SQL

    # Cambiar el tipo de columna a integer usando una expresión USING
    change_column :professionals, :specialty, :integer, using: 'specialty::integer', default: 0, null: false
  end

  def down
    # Revertir el cambio convirtiendo la columna de vuelta a string
    change_column :professionals, :specialty, :string
  end
end