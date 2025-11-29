class CreateSystemBusinesses < ActiveRecord::Migration[8.1]
  def change
    create_table :businesses,
                 comment: "Stores system businesses with unique identifiers, formats" do |t|
      t.string  :encoded_key,
                comment: "Opaque key (encoded) for external references or integrations"
      t.string  :unique_id,
                comment: "Business unique identifier, must be unique when present"
      t.string  :name,
                comment: "Business display name"
      t.string  :time_format,
                comment: "Preferred time format string (e.g., HH:MM, 12h/24h)"
      t.string  :datetime_format,
                comment: "Preferred datetime format string (e.g., ISO8601, custom patterns)"

      t.timestamps comment: "Created/Updated timestamps"
    end

    # Unique constraint index for unique_id when present
    add_index :businesses, [ :unique_id ],
              unique: true,
              where: "unique_id IS NOT NULL",
              name: "index_businesses_on_unique_id_not_null"

    # Index on encoded_key for fast lookups if used as identifier
    add_index :businesses, [ :encoded_key ],
              unique: true,
              name: "index_businesses_on_encoded_key"
  end
end
