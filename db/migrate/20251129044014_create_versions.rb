class CreateVersions < ActiveRecord::Migration[8.1]
  TEXT_BYTES = 1_073_741_823

  def change
    create_table :versions,
                 comment: "Audit log of changes to records, maintained by PaperTrail (PT)" do |t|
      t.bigint   :whodunnit,
                 comment: "ID of the user or actor responsible for the change"
      t.datetime :created_at,
                 comment: "Timestamp when version was created; fractional seconds precision recommended for MySQL"
      t.boolean  :is_api,
                 default: false,
                 null: false,
                 comment: "Indicates if the change originated from an API call"
      t.bigint   :item_id,
                 null: false,
                 comment: "Primary key of the versioned record"
      t.string   :item_type,
                 null: false,
                 comment: "Type of the versioned record (STI class name)"
      t.string   :event,
                 null: false,
                 comment: "Type of change event (create, update, destroy)"
      t.string   :full_name,
                 comment: "Full name of the actor who made the change (if available)"
      t.text     :object,
                 limit: TEXT_BYTES,
                 comment: "Serialized object state before the change"
      t.jsonb    :object_changes,
                 comment: "Changes applied to the object, stored as JSONB"
      t.references :business,
                   null: false,
                   foreign_key: true,
                   comment: "Associated business context for the version"
    end

    # Composite index optimizes queries by item reference and business scope
    add_index :versions, %i[item_type item_id business_id],
              name: "index_versions_on_item_and_business"

    # Additional index for chronological queries
    add_index :versions, :created_at,
              name: "index_versions_on_created_at"

    # GIN index for efficient key/value search in JSONB column
    add_index :versions, :object_changes,
              using: :gin,
              name: "index_versions_on_object_changes_gin"

    # Partial index for fast filtering of API-originated changes
    add_index :versions, :is_api,
              where: "is_api = true",
              name: "index_versions_on_is_api_true"
  end
end