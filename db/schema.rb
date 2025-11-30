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

ActiveRecord::Schema[8.1].define(version: 2025_11_30_054002) do
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

  create_table "addresses", comment: "Stores shared address information for businesses and other customizable entities", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Owning business that this address belongs to"
    t.string "city", comment: "The city of the address"
    t.string "country", comment: "The country of the address"
    t.datetime "created_at", null: false, comment: "Created/Updated timestamps"
    t.bigint "customizable_id", comment: "Polymorphic association to any customizable entity (e.g., User, Location) that this address customizes"
    t.string "customizable_type"
    t.string "encoded_key", comment: "Opaque key (encoded) for external references or integrations"
    t.string "region", comment: "The region, state, or province of the address"
    t.string "street_name", comment: "The primary street name and number of the address"
    t.string "unique_id", comment: "Business-specific unique identifier for the address, if applicable. Can be NULL."
    t.datetime "updated_at", null: false, comment: "Created/Updated timestamps"
    t.index ["business_id", "customizable_type", "customizable_id"], name: "idx_addresses_on_business_customizable"
    t.index ["business_id", "unique_id"], name: "idx_addresses_on_business_id_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["business_id"], name: "idx_addresses_on_business_id"
    t.index ["business_id"], name: "index_addresses_on_business_id"
    t.index ["city"], name: "idx_addresses_on_city"
    t.index ["country"], name: "idx_addresses_on_country"
    t.index ["customizable_type", "customizable_id"], name: "index_addresses_on_customizable"
    t.index ["unique_id"], name: "idx_addresses_on_unique_id_global", unique: true, where: "(unique_id IS NOT NULL)"
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

  create_table "contacts", comment: "Stores contact information (emails, phones) linked to businesses and customizable entities", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Owning business that this contact belongs to"
    t.datetime "created_at", null: false, comment: "Created/Updated timestamps"
    t.bigint "customizable_id", comment: "Polymorphic association to any customizable entity (e.g., User, Customer)"
    t.string "customizable_type"
    t.string "encoded_key", comment: "Opaque key (encoded) for external references or integrations"
    t.string "primary_email", comment: "Primary email address of the contact"
    t.string "primary_phone_number", comment: "Primary phone number of the contact"
    t.string "secondary_email", comment: "Secondary email address of the contact"
    t.string "secondary_phone_number", comment: "Secondary phone number of the contact"
    t.string "unique_id", comment: "Business-specific unique identifier for the contact"
    t.datetime "updated_at", null: false, comment: "Created/Updated timestamps"
    t.index ["business_id", "customizable_type", "customizable_id"], name: "index_contacts_on_business_and_customizable"
    t.index ["business_id", "primary_email"], name: "index_contacts_on_business_id_and_primary_email"
    t.index ["business_id", "primary_phone_number"], name: "index_contacts_on_business_id_and_primary_phone_number"
    t.index ["business_id", "unique_id"], name: "index_contacts_on_business_id_and_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["business_id"], name: "index_contacts_on_business_id"
    t.index ["customizable_type", "customizable_id"], name: "index_contacts_on_customizable"
  end

  create_table "invitations", comment: "Tracks user invitations to a business, including status, inviter, and branch assignment", force: :cascade do |t|
    t.datetime "accepted_at", comment: "Timestamp when the invitation was accepted"
    t.bigint "assigned_branch_id", null: false, comment: "Branch assigned to the invited user"
    t.bigint "business_id", null: false, comment: "Reference to the owning business"
    t.datetime "created_at", null: false
    t.string "email_address", comment: "Email address of the invitee"
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.string "firstname", comment: "First name of the invited user"
    t.bigint "inviter_id", comment: "Reference to the user who sent the invitation"
    t.string "lastname", comment: "Last name of the invited user"
    t.integer "status", default: 0, null: false, comment: "Status of the invitation (e.g., pending = 0, accepted = 1, declined = 2)"
    t.string "time_zone", comment: "Time zone of the invitee"
    t.string "unique_id", comment: "Optional unique identifier within the business"
    t.datetime "updated_at", null: false
    t.index ["assigned_branch_id"], name: "index_invitations_on_assigned_branch_id"
    t.index ["business_id", "email_address"], name: "index_invitations_on_business_email", unique: true
    t.index ["business_id", "status"], name: "index_invitations_pending", where: "((status = 0) AND (accepted_at IS NULL))"
    t.index ["business_id", "unique_id"], name: "index_invitations_on_business_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["business_id"], name: "index_invitations_on_business_id"
    t.index ["inviter_id"], name: "index_invitations_on_inviter_id"
    t.index ["status"], name: "index_invitations_on_status"
  end

  create_table "permission_nodes", comment: "Hierarchical nodes representing permissions within a business", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Reference to the business this permission node belongs to"
    t.datetime "created_at", null: false
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.boolean "is_model", default: false, null: false, comment: "Indicates if this node represents a model-level permission"
    t.string "name", null: false, comment: "Human-readable name of the permission node"
    t.bigint "parent_id", comment: "Optional reference to a parent permission node for hierarchy"
    t.string "path", comment: "Materialized path or hierarchy path for tree structure"
    t.integer "permission_nodes_count", default: 0, null: false, comment: "Counter cache for child nodes"
    t.string "unique_id", comment: "Optional unique identifier within a business"
    t.datetime "updated_at", null: false
    t.index ["business_id", "name"], name: "index_permission_nodes_on_business_and_name", unique: true
    t.index ["business_id", "unique_id"], name: "index_permission_nodes_on_business_and_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["business_id"], name: "index_permission_nodes_on_business_id"
    t.index ["is_model"], name: "index_permission_nodes_on_is_model"
    t.index ["parent_id"], name: "index_permission_nodes_on_parent_id"
    t.index ["path"], name: "index_permission_nodes_on_path"
    t.index ["permission_nodes_count"], name: "index_permission_nodes_on_permission_nodes_count"
  end

  create_table "permissions", comment: "System permissions for roles within a business", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Reference to the business this permission belongs to"
    t.datetime "created_at", null: false
    t.text "description", comment: "Optional description of what this permission allows"
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.string "name", null: false, comment: "Human-readable name of the permission"
    t.string "unique_id", comment: "Optional unique identifier within a business"
    t.datetime "updated_at", null: false
    t.index ["business_id", "name"], name: "index_permissions_on_business_and_name", unique: true
    t.index ["business_id", "unique_id"], name: "index_permissions_on_business_and_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["business_id"], name: "index_permissions_on_business_id"
    t.index ["name"], name: "index_permissions_on_name"
  end

  create_table "pg_search_documents", comment: "Table used by pg_search for multisearch across models", force: :cascade do |t|
    t.text "content", comment: "Searchable text extracted from associated records"
    t.datetime "created_at", null: false, comment: "Timestamps for tracking document creation and updates"
    t.bigint "searchable_id", comment: "Polymorphic association to any searchable model (e.g., Post, Comment, User)"
    t.string "searchable_type"
    t.datetime "updated_at", null: false, comment: "Timestamps for tracking document creation and updates"
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "role_permissions", comment: "Associates roles with permissions and permission nodes within a business, indicating access rights", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Reference to the business this role permission belongs to"
    t.boolean "can_access", comment: "Indicates whether the role has access to this permission node"
    t.datetime "created_at", null: false
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.bigint "permission_id", null: false, comment: "Reference to the permission"
    t.bigint "permission_node_id", null: false, comment: "Reference to the permission node"
    t.bigint "role_id", null: false, comment: "Reference to the role"
    t.string "unique_id", comment: "Optional unique identifier within a business"
    t.datetime "updated_at", null: false
    t.index ["business_id", "role_id"], name: "index_role_permissions_on_business_and_role"
    t.index ["business_id", "unique_id"], name: "index_role_permissions_on_business_and_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["business_id"], name: "index_role_permissions_on_business_id"
    t.index ["can_access"], name: "index_role_permissions_on_can_access"
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["permission_node_id"], name: "index_role_permissions_on_permission_node_id"
    t.index ["role_id", "permission_id"], name: "index_role_permissions_on_role_and_permission"
    t.index ["role_id", "permission_node_id"], name: "index_role_permissions_on_role_and_node"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", comment: "Roles within a business organization, defining permissions and access levels", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Reference to the business this role belongs to"
    t.datetime "created_at", null: false
    t.text "description", comment: "Optional description of the role"
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.string "name", null: false, comment: "Human-readable name of the role"
    t.integer "status", default: 0, null: false, comment: "Status of the role (e.g., active, inactive)"
    t.string "unique_id", comment: "Optional unique identifier within a business"
    t.datetime "updated_at", null: false
    t.index ["business_id", "name"], name: "index_roles_on_business_and_name", unique: true
    t.index ["business_id", "unique_id"], name: "index_roles_on_business_and_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["business_id"], name: "index_roles_on_business_id"
    t.index ["status"], name: "index_roles_on_status"
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

  create_table "user_branches", comment: "Associates users with branches within a business", force: :cascade do |t|
    t.bigint "branch_id", null: false, comment: "Reference to the branch"
    t.bigint "business_id", null: false, comment: "Reference to the owning business"
    t.datetime "created_at", null: false
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.string "unique_id", comment: "Optional unique identifier within a business"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "Reference to the user"
    t.index ["branch_id"], name: "index_user_branches_on_branch_id"
    t.index ["business_id", "branch_id", "user_id"], name: "index_user_branches_on_business_branch_user", unique: true
    t.index ["business_id"], name: "index_user_branches_on_business_id"
    t.index ["unique_id"], name: "index_user_branches_on_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["user_id", "branch_id"], name: "index_user_branches_active_user_branch"
    t.index ["user_id"], name: "index_user_branches_on_user_id"
  end

  create_table "user_roles", comment: "Associates users with roles within a business", force: :cascade do |t|
    t.bigint "business_id", null: false, comment: "Reference to the owning business"
    t.datetime "created_at", null: false
    t.string "encoded_key", comment: "Optional encoded key for internal reference"
    t.bigint "role_id", null: false, comment: "Reference to the role"
    t.string "unique_id", comment: "Optional unique identifier within a business"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "Reference to the user"
    t.index ["business_id", "user_id", "role_id"], name: "index_user_roles_on_business_user_role", unique: true
    t.index ["business_id"], name: "index_user_roles_on_business_id"
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["unique_id"], name: "index_user_roles_on_unique_id", unique: true, where: "(unique_id IS NOT NULL)"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
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
  add_foreign_key "addresses", "businesses"
  add_foreign_key "branches", "businesses"
  add_foreign_key "contacts", "businesses"
  add_foreign_key "invitations", "branches", column: "assigned_branch_id"
  add_foreign_key "invitations", "businesses"
  add_foreign_key "invitations", "users", column: "inviter_id"
  add_foreign_key "permission_nodes", "businesses"
  add_foreign_key "permission_nodes", "permission_nodes", column: "parent_id"
  add_foreign_key "permissions", "businesses"
  add_foreign_key "role_permissions", "businesses"
  add_foreign_key "role_permissions", "permission_nodes"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "roles", "businesses"
  add_foreign_key "sessions", "businesses"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_branches", "branches"
  add_foreign_key "user_branches", "businesses"
  add_foreign_key "user_branches", "users"
  add_foreign_key "user_roles", "businesses"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "branches", column: "assigned_branch_id"
  add_foreign_key "users", "businesses"
  add_foreign_key "versions", "businesses"
end
