class CreateSharedAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses,
                 comment: "Stores shared address information for businesses and other customizable entities" do |t|
      t.string :encoded_key,
               comment: "Opaque key (encoded) for external references or integrations"
      t.string :unique_id,
               comment: "Business-specific unique identifier for the address, if applicable. Can be NULL."
      t.string :street_name,
               comment: "The primary street name and number of the address"
      t.string :city,
               comment: "The city of the address"
      t.string :region,
               comment: "The region, state, or province of the address"
      t.string :country,
               comment: "The country of the address"
      t.references :customizable,
                   polymorphic: true,
                   null: true,
                   comment: "Polymorphic association to any customizable entity (e.g., User, Location) that this address customizes"
      t.references :business,
                   null: false,
                   foreign_key: true,
                   comment: "Owning business that this address belongs to"

      t.timestamps comment: "Created/Updated timestamps"
    end

    # Ensure uniqueness of unique_id within a business for efficient lookups and data integrity.
    add_index :addresses, %i[business_id unique_id],
              unique: true,
              where: 'unique_id IS NOT NULL',
              name: 'idx_addresses_on_business_id_unique_id'

    # Support polymorphic lookups: efficiently retrieve addresses for a specific customizable
    # entity belonging to a particular business.
    add_index :addresses, %i[business_id customizable_type customizable_id],
              name: 'idx_addresses_on_business_customizable'

    # Optimize queries that retrieve all addresses for a given business.
    add_index :addresses, :business_id,
              name: 'idx_addresses_on_business_id'

    # Allow fast global lookups by unique_id, ensuring its uniqueness across all non-null entries.
    add_index :addresses, :unique_id,
              unique: true,
              where: 'unique_id IS NOT NULL',
              name: 'idx_addresses_on_unique_id_global'

    # Speed up queries that filter or sort addresses by city.
    add_index :addresses, :city,
              name: 'idx_addresses_on_city'

    # Speed up queries that filter or sort addresses by country.
    add_index :addresses, :country,
              name: 'idx_addresses_on_country'
  end
end
