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

ActiveRecord::Schema[8.1].define(version: 2025_11_29_044014) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  add_foreign_key "versions", "businesses"
end
