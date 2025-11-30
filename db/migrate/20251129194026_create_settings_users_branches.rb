class CreateSettingsUsersBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :user_branches, comment: 'Associates users with branches within a business' do |t|
      t.string :unique_id, comment: 'Optional unique identifier within a business'
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'
      t.references :user, null: false, foreign_key: true, comment: 'Reference to the user'
      t.references :branch, null: false, foreign_key: true, comment: 'Reference to the branch'
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the owning business'

      t.timestamps
    end

    # Unique constraint to prevent duplicate assignments
    add_index :user_branches, %i[business_id branch_id user_id], unique: true, name: 'index_user_branches_on_business_branch_user'

    # Partial index for unique_id
    add_index :user_branches, :unique_id, unique: true, where: 'unique_id IS NOT NULL', name: 'index_user_branches_on_unique_id'

    # Partial index for active user-branch assignments
    add_index :user_branches, %i[user_id branch_id], name: 'index_user_branches_active_user_branch'
  end
end
