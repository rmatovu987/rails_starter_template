class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, comment: 'Users belonging to a business, including branch assignments, roles, and authentication info' do |t|
      t.string :firstname, comment: 'First name of the user'
      t.string :lastname, comment: 'Last name of the user'
      t.string :time_zone, comment: 'User-specific time zone'
      t.string :email_address, null: false, comment: 'User email used for login; unique within a business'
      t.integer :status, null: false, default: 0, comment: 'Status of the user (e.g., active = 1, inactive = 0)'
      t.string :unique_id, comment: 'Optional unique identifier within a business'
      t.string :password_digest, comment: 'Hashed password for authentication'
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'
      t.boolean :super_user, comment: 'Indicates whether the user is a super admin'
      t.datetime :last_password_change_at, comment: 'Timestamp of the last password update'
      t.references :assigned_branch, null: false, foreign_key: { to_table: :branches }, comment: 'Branch this user is assigned to'
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the owning business'

      t.timestamps
    end

    # Unique constraints
    add_index :users, %i[business_id email_address], unique: true, name: 'index_users_on_business_and_email'
    add_index :users, %i[business_id unique_id],
              unique: true,
              where: 'unique_id IS NOT NULL',
              name: 'index_users_on_business_and_unique_id'

    # Standard indices
    add_index :users, :last_password_change_at, name: 'index_users_on_last_password_change_at'

    # Partial indices for fast lookups
    add_index :users, :status, name: 'index_users_on_active_status', where: "status = 1"
    add_index :users, :super_user, name: 'index_users_on_super_user_true', where: "super_user = TRUE"
  end
end
