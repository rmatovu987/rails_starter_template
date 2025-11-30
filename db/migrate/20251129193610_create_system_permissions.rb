class CreateSystemPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions, comment: 'System permissions for roles within a business' do |t|
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the business this permission belongs to'
      t.string :name, null: false, comment: 'Human-readable name of the permission'
      t.text :description, comment: 'Optional description of what this permission allows'
      t.string :unique_id, comment: 'Optional unique identifier within a business'
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'

      t.timestamps
    end

    # Unique constraints
    add_index :permissions, %i[business_id name], unique: true, name: 'index_permissions_on_business_and_name'
    add_index :permissions, %i[business_id unique_id],
              unique: true,
              where: 'unique_id IS NOT NULL',
              name: 'index_permissions_on_business_and_unique_id'

    # Suggested additional indices for performance
    add_index :permissions, :name, name: 'index_permissions_on_name'
  end
end
