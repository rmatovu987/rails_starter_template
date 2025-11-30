class CreateSettingsUsersRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_roles, comment: 'Associates users with roles within a business' do |t|
      t.string :unique_id, comment: 'Optional unique identifier within a business'
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'
      t.references :user, null: false, foreign_key: true, comment: 'Reference to the user'
      t.references :role, null: false, foreign_key: true, comment: 'Reference to the role'
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the owning business'

      t.timestamps
    end

    # Unique constraint to prevent duplicate user-role assignments within a business
    add_index :user_roles, %i[business_id user_id role_id], unique: true, name: 'index_user_roles_on_business_user_role'

    # Partial index for unique_id
    add_index :user_roles, :unique_id, unique: true, where: 'unique_id IS NOT NULL', name: 'index_user_roles_on_unique_id'

    # Partial indices for active assignments
  end
end
