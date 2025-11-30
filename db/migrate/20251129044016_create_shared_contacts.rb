# db/migrate/20230819125000_create_shared_contacts.rb
class CreateSharedContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts,
                 comment: "Stores contact information (emails, phones) linked to businesses and customizable entities" do |t|
      t.string  :encoded_key,
                comment: "Opaque key (encoded) for external references or integrations"
      t.string  :unique_id,
                comment: "Business-specific unique identifier for the contact"
      t.string  :primary_email,
                comment: "Primary email address of the contact"
      t.string  :secondary_email,
                comment: "Secondary email address of the contact"
      t.string  :primary_phone_number,
                comment: "Primary phone number of the contact"
      t.string  :secondary_phone_number,
                comment: "Secondary phone number of the contact"

      t.references :customizable,
                   polymorphic: true,
                   null: true,
                   comment: "Polymorphic association to any customizable entity (e.g., User, Customer)"
      t.references :business,
                   null: false,
                   foreign_key: true,
                   comment: "Owning business that this contact belongs to"

      t.timestamps comment: "Created/Updated timestamps"
    end

    # Ensure uniqueness of unique_id within a business
    add_index :contacts, %i[business_id unique_id],
              unique: true,
              where: "unique_id IS NOT NULL",
              name: "index_contacts_on_business_id_and_unique_id"

    # Support polymorphic lookups within a business
    add_index :contacts, %i[business_id customizable_type customizable_id],
              name: "index_contacts_on_business_and_customizable"

    # Fast lookups by primary_email within business
    add_index :contacts, %i[business_id primary_email],
              name: "index_contacts_on_business_id_and_primary_email"

    # Fast lookups by primary_phone_number within business
    add_index :contacts, %i[business_id primary_phone_number],
              name: "index_contacts_on_business_id_and_primary_phone_number"
  end
end
