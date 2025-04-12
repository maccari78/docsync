ActiveRecord::Schema[7.1].define(version: 2025_04_03_220836) do
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "patient_id", null: false
    t.uuid "professional_id", null: false
    t.uuid "clinic_id", null: false
    t.date "date"
    t.time "time"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "treatment_details"
    t.datetime "deleted_at"
    t.index ["clinic_id"], name: "index_appointments_on_clinic_id"
    t.index ["deleted_at"], name: "index_appointments_on_deleted_at"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["professional_id"], name: "index_appointments_on_professional_id"
  end

  create_table "clinics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "phone"
    t.uuid "professional_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["professional_id"], name: "index_patients_on_professional_id"
  end

  create_table "payments", force: :cascade do |t|
    t.uuid "appointment_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "status", default: 0, null: false
    t.string "external_payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_payments_on_appointment_id"
  end

  create_table "professionals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "specialty", default: 0, null: false
    t.string "license_number"
    t.uuid "clinic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id"], name: "index_professionals_on_clinic_id"
    t.index ["user_id"], name: "index_professionals_on_user_id"
  end

  create_table "professionals_secretaries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "professional_id", null: false
    t.uuid "secretary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["professional_id"], name: "index_professionals_secretaries_on_professional_id"
    t.index ["secretary_id"], name: "index_professionals_secretaries_on_secretary_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.uuid "clinic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "first_name"
    t.string "last_name"
    t.string "provider"
    t.string "uid"
    t.index ["clinic_id"], name: "index_users_on_clinic_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "clinics"
  add_foreign_key "appointments", "patients"
  add_foreign_key "appointments", "professionals"
  add_foreign_key "patients", "users", column: "professional_id"
  add_foreign_key "payments", "appointments"
  add_foreign_key "professionals", "clinics"
  add_foreign_key "professionals", "users"
  add_foreign_key "professionals_secretaries", "professionals"
  add_foreign_key "professionals_secretaries", "users", column: "secretary_id"
  add_foreign_key "users", "clinics"
end
