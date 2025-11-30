# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_30_024003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "branches", comment: "Represents branches of a business, including main and active/deleted status", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Reference to the owning business"
    t.string "code", comment: "Optional short code identifying the branch"
    t.datetime "created_at", null: false
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.boolean "isMain", default: false, null: false, comment: "Indicates if this is the main branch"
    t.string "name", null: false, comment: "Human-readable name of the branch"
    t.integer "status", default: 0, null: false, comment: "Status of the branch (e.g., active, inactive)"
    t.string "unique_id", comment: "Optional unique identifier within a business"
    t.datetime "updated_at", null: false
    t.index ["business_id", "name"], name: "index_branches_on_business_and_name", unique: true
    t.index ["business_id", "unique_id"], name: "index_branches_on_business_and_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["business_id"], name: "index_branches_on_business_id"
    t.index ["isMain"], name: "index_branches_on_isMain"
    t.index ["status"], name: "index_branches_on_status"
  end

  create_table "businesses", comment: "Stores system businesses with unique identifiers, formats", force: :cascade do |t|
    t.datetime "created_at", null: false, comment: "Created/Updated timestamps"
    t.string "datetime_format", comment: "Preferred datetime format string (e.g., ISO8601, custom patterns)"
    t.string "encoded_key", comment: "Opaque key (encoded) for external references or integrations"
    t.string "name", comment: "Business display name"
    t.string "time_format", comment: "Preferred time format string (e.g., HH:MM, 12h/24h)"
    t.string "unique_id", comment: "Business unique identifier, must be unique when present"
    t.datetime "updated_at", null: false, comment: "Created/Updated timestamps"
    t.index ["encoded_key"], name: "index_businesses_on_encoded_key", unique: true
    t.index ["unique_id"], name: "index_businesses_on_unique_id_not_null", unique: true, where: "(unique_id IS NOT NULL)"
  end

  create_table "pg_search_documents", comment: "Table used by pg_search for multisearch across models", force: :cascade do |t|
    t.text "content", comment: "Searchable text extracted from associated records"
    t.datetime "created_at", null: false, comment: "Timestamps for tracking document creation and updates"
    t.bigint "searchable_id", comment: "Polymorphic association to any searchable model (e.g., Post, Comment, User)"
    t.string "searchable_type"
    t.datetime "updated_at", null: false, comment: "Timestamps for tracking document creation and updates"
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "sessions", comment: "Stores user sessions with device, location, and risk information", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Reference to the business associated with the session"
    t.string "city", comment: "City of the session location"
    t.string "country", comment: "Country of the session location"
    t.string "country_code", comment: "Country code of the session location"
    t.datetime "created_at", null: false
    t.string "device_details", comment: "Device details of the client"
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.datetime "expired_at", comment: "Session expiration timestamp"
    t.string "ip_address", comment: "IP address of the session"
    t.boolean "is_mobile", default: false, null: false, comment: "Indicates if the session was from a mobile device"
    t.jsonb "isp", comment: "ISP information for the session"
    t.datetime "last_access", comment: "Timestamp of the last activity in this session"
    t.string "latitude", comment: "Latitude of the session location"
    t.string "localtime", comment: "Local time of the session"
    t.string "longitude", comment: "Longitude of the session location"
    t.jsonb "risk", comment: "Risk assessment data for the session"
    t.string "state", comment: "State of the session location"
    t.string "timezone", comment: "Timezone of the session"
    t.string "unique_id", comment: "Optional unique identifier for the session"
    t.datetime "updated_at", null: false
    t.string "user_agent", comment: "User agent string of the client"
    t.bigint "user_id", null: false, comment: "Reference to the user who owns the session"
    t.string "zipcode", comment: "Zip code of the session location"
    t.index ["business_id"], name: "index_sessions_on_business_id"
    t.index ["expired_at"], name: "index_sessions_on_expired_at"
    t.index ["ip_address"], name: "index_sessions_on_ip_address"
    t.index ["last_access"], name: "index_sessions_on_last_access"
    t.index ["unique_id"], name: "index_sessions_on_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["user_id", "business_id"], name: "index_sessions_active_user_business", where: "(expired_at IS NULL)"
    t.index ["user_id", "is_mobile"], name: "index_sessions_active_mobile", where: "((expired_at IS NULL) AND (is_mobile = true))"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", comment: "Users belonging to a business, including branch assignments, roles, and authentication info", force: :cascade do |t|
    t.bigint "assigned_branch_id", null: false, comment: "Branch this user is assigned to"
    t.bigint "business_id", null: false, comment: "Reference to the owning business"
    t.datetime "created_at", null: false
    t.string "email_address", null: false, comment: "User email used for login; unique within a business"
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.string "firstname", comment: "First name of the user"
    t.datetime "last_password_change_at", comment: "Timestamp of the last password update"
    t.string "lastname", comment: "Last name of the user"
    t.string "password_digest", comment: "Hashed password for authentication"
    t.integer "status", default: 0, null: false, comment: "Status of the user (e.g., active = 1, inactive = 0)"
    t.boolean "super_user", comment: "Indicates whether the user is a super admin"
    t.string "time_zone", comment: "User-specific time zone"
    t.string "unique_id", comment: "Optional unique identifier within a business"
    t.datetime "updated_at", null: false
    t.index ["assigned_branch_id"], name: "index_users_on_assigned_branch_id"
    t.index ["business_id", "email_address"], name: "index_users_on_business_and_email", unique: true
    t.index ["business_id", "unique_id"], name: "index_users_on_business_and_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["business_id"], name: "index_users_on_business_id"
    t.index ["last_password_change_at"], name: "index_users_on_last_password_change_at"
    t.index ["status"], name: "index_users_on_active_status", where: "(status = 1)"
    t.index ["super_user"], name: "index_users_on_super_user_true", where: "(super_user = true)"
  end

  create_table "versions", comment: "Audit log of changes to records, maintained by PaperTrail (PT)", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Associated business context for the version"
    t.datetime "created_at", comment: "Timestamp when version was created; fractional seconds precision recommended for MySQL"
    t.string "event", null: false, comment: "Type of change event (create, update, destroy)"
    t.string "full_name", comment: "Full name of the actor who made the change (if available)"
    t.boolean "is_api", default: false, null: false, comment: "Indicates if the change originated from an API call"
    t.bigint "item_id", null: false, comment: "Primary key of the versioned record"
    t.string "item_type", null: false, comment: "Type of the versioned record (STI class name)"
    t.text "object", comment: "Serialized object state before the change"
    t.jsonb "object_changes", comment: "Changes applied to the object, stored as JSONB"
    t.bigint "whodunnit", comment: "ID of the user or actor responsible for the change"
    t.index ["business_id"], name: "index_versions_on_business_id"
    t.index ["created_at"], name: "index_versions_on_created_at"
    t.index ["is_api"], name: "index_versions_on_is_api_true", where: "(is_api = true)"
    t.index ["item_type", "item_id", "business_id"], name: "index_versions_on_item_and_business"
    t.index ["object_changes"], name: "index_versions_on_object_changes_gin", using: :gin
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "branches", "businesses"
  add_foreign_key "sessions", "businesses"
  add_foreign_key "sessions", "users"
  add_foreign_key "users", "branches", column: "assigned_branch_id"
  add_foreign_key "users", "businesses"
  add_foreign_key "versions", "businesses"
end
