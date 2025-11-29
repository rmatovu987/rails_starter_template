class CreateSystemBranches < ActiveRecord::Migration[8.1]
  def change
    create_table :branches, comment: 'Represents branches of a business, including main and active/deleted status' do |t|
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'
      t.string :unique_id, comment: 'Optional unique identifier within a business'
      t.string :name, null: false, comment: 'Human-readable name of the branch'
      t.string :code, comment: 'Optional short code identifying the branch'
      t.boolean :isMain, null: false, default: false, comment: 'Indicates if this is the main branch'
      t.integer :status, null: false, default: 0, comment: 'Status of the branch (e.g., active, inactive)'
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the owning business'

      t.timestamps
    end

    # Unique constraints
    add_index :branches, %i[business_id name], unique: true, name: 'index_branches_on_business_and_name'
    add_index :branches, %i[business_id unique_id],
              unique: true,
              where: 'unique_id IS NOT NULL',
              name: 'index_branches_on_business_and_unique_id'

    # Suggested additional indices for performance
    add_index :branches, :isMain, name: 'index_branches_on_isMain'
    add_index :branches, :status, name: 'index_branches_on_status'
  end
end
