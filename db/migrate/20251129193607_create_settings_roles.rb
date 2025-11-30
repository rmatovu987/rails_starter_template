class CreateSettingsRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles, comment: 'Roles within a business organization, defining permissions and access levels' do |t|
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the business this role belongs to'
      t.string :name, null: false, comment: 'Human-readable name of the role'
      t.text :description, comment: 'Optional description of the role'
      t.integer :status, null: false, default: 0, comment: 'Status of the role (e.g., active, inactive)'
      t.string :unique_id, comment: 'Optional unique identifier within a business'
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'

      t.timestamps
    end

    # Unique constraints
    add_index :roles, %i[business_id name], unique: true, name: 'index_roles_on_business_and_name'
    add_index :roles, %i[business_id unique_id],
              unique: true,
              where: 'unique_id IS NOT NULL',
              name: 'index_roles_on_business_and_unique_id'

    # Suggested additional indices for performance
    add_index :roles, :status, name: 'index_roles_on_status'
  end
end
