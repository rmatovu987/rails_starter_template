class CreatePgSearchDocuments < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Creating table for pg_search multisearch") do
      create_table :pg_search_documents, comment: "Table used by pg_search for multisearch across models" do |t|
        t.text :content, comment: "Searchable text extracted from associated records"
        t.belongs_to :searchable,
                     polymorphic: true,
                     index: true,
                     comment: "Polymorphic association to any searchable model (e.g., Post, Comment, User)"
        t.timestamps null: false, comment: "Timestamps for tracking document creation and updates"
      end
    end
  end

  def down
    say_with_time("Dropping table for pg_search multisearch") do
      drop_table :pg_search_documents
    end
  end
end
