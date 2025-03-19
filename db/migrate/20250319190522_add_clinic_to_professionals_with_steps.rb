class AddClinicToProfessionalsWithSteps < ActiveRecord::Migration[7.1]
  def change
    # Paso 1: Agregar la columna clinic_id sin restricción NOT NULL
    add_reference :professionals, :clinic, foreign_key: true

    # Paso 2: Asignar un valor por defecto a los registros existentes
    reversible do |dir|
      dir.up do
        # Buscar una clínica existente (por ejemplo, "Dental Clinic 1")
        default_clinic = Clinic.find_by(name: "Dental Clinic 1")
        if default_clinic
          # Actualizar todos los profesionales existentes para que pertenezcan a esta clínica
          Professional.where(clinic_id: nil).update_all(clinic_id: default_clinic.id)
        else
          # Si no hay clínicas, crear una por defecto
          default_clinic = Clinic.create!(name: "Default Clinic", address: "123 Default St")
          Professional.where(clinic_id: nil).update_all(clinic_id: default_clinic.id)
        end
      end
    end

    # Paso 3: Agregar la restricción NOT NULL después de asegurarnos de que no hay valores nulos
    change_column_null :professionals, :clinic_id, false
  end
end