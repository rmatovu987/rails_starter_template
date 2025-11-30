class CreateSettingsInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :invitations, comment: 'Tracks user invitations to a business, including status, inviter, and branch assignment' do |t|
      t.string :firstname, comment: 'First name of the invited user'
      t.string :lastname, comment: 'Last name of the invited user'
      t.string :email_address, comment: 'Email address of the invitee'
      t.string :time_zone, comment: 'Time zone of the invitee'
      t.string :unique_id, comment: 'Optional unique identifier within the business'
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'
      t.integer :status, null: false, default: 0, comment: 'Status of the invitation (e.g., pending = 0, accepted = 1, declined = 2)'
      t.datetime :accepted_at, comment: 'Timestamp when the invitation was accepted'
      t.references :inviter, foreign_key: { to_table: :users }, comment: 'Reference to the user who sent the invitation'
      t.references :assigned_branch, null: false, foreign_key: { to_table: :branches }, comment: 'Branch assigned to the invited user'
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the owning business'

      t.timestamps
    end

    # Unique constraint on email per business
    add_index :invitations, %i[business_id email_address], unique: true, name: 'index_invitations_on_business_email'

    # Unique constraint on unique_id per business
    add_index :invitations, %i[business_id unique_id],
              unique: true,
              where: 'unique_id IS NOT NULL',
              name: 'index_invitations_on_business_unique_id'

    # Standard indices
    add_index :invitations, :status, name: 'index_invitations_on_status'

    # Partial index for active (pending) invitations
    add_index :invitations, %i[business_id status], name: 'index_invitations_pending', where: 'status = 0 AND accepted_at IS NULL'
  end
end
