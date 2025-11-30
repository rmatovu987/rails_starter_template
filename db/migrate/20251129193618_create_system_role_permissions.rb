class CreateSystemRolePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :role_permissions, comment: 'Associates roles with permissions and permission nodes within a business, indicating access rights' do |t|
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the business this role permission belongs to'
      t.references :role, null: false, foreign_key: true, comment: 'Reference to the role'
      t.references :permission, null: false, foreign_key: true, comment: 'Reference to the permission'
      t.references :permission_node, null: false, foreign_key: true, comment: 'Reference to the permission node'
      t.boolean :can_access, comment: 'Indicates whether the role has access to this permission node'
      t.string :unique_id, comment: 'Optional unique identifier within a business'
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'

      t.timestamps
    end

    # Unique constraints
    add_index :role_permissions, %i[business_id unique_id],
              unique: true,
              where: 'unique_id IS NOT NULL',
              name: 'index_role_permissions_on_business_and_unique_id'

    # Suggested additional indices for performance
    add_index :role_permissions, %i[role_id permission_node_id], name: 'index_role_permissions_on_role_and_node'
    add_index :role_permissions, %i[role_id permission_id], name: 'index_role_permissions_on_role_and_permission'
    add_index :role_permissions, %i[business_id role_id], name: 'index_role_permissions_on_business_and_role'
    add_index :role_permissions, :can_access, name: 'index_role_permissions_on_can_access'
  end
end
