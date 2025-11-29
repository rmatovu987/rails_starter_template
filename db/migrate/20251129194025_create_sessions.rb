class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions, comment: 'Stores user sessions with device, location, and risk information' do |t|
      t.references :user, null: false, foreign_key: true, comment: 'Reference to the user who owns the session'
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the business associated with the session'
      t.string :ip_address, comment: 'IP address of the session'
      t.string :user_agent, comment: 'User agent string of the client'
      t.string :unique_id, comment: 'Optional unique identifier for the session'
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'
      t.string :latitude, comment: 'Latitude of the session location'
      t.string :longitude, comment: 'Longitude of the session location'
      t.string :city, comment: 'City of the session location'
      t.string :device_details, comment: 'Device details of the client'
      t.string :state, comment: 'State of the session location'
      t.string :country, comment: 'Country of the session location'
      t.string :country_code, comment: 'Country code of the session location'
      t.string :timezone, comment: 'Timezone of the session'
      t.string :localtime, comment: 'Local time of the session'
      t.string :zipcode, comment: 'Zip code of the session location'
      t.boolean :is_mobile, null: false, default: false, comment: 'Indicates if the session was from a mobile device'
      t.jsonb :isp, comment: 'ISP information for the session'
      t.jsonb :risk, comment: 'Risk assessment data for the session'
      t.datetime :expired_at, comment: 'Session expiration timestamp'
      t.datetime :last_access, comment: 'Timestamp of the last activity in this session'

      t.timestamps
    end

    # Standard indices
    add_index :sessions, :ip_address, name: 'index_sessions_on_ip_address'
    add_index :sessions, :unique_id, unique: true, where: 'unique_id IS NOT NULL', name: 'index_sessions_on_unique_id'
    add_index :sessions, :last_access, name: 'index_sessions_on_last_access'
    add_index :sessions, :expired_at, name: 'index_sessions_on_expired_at'

    # Partial indices for active sessions (not expired)
    add_index :sessions, %i[user_id business_id], name: 'index_sessions_active_user_business',
              where: 'expired_at IS NULL'
    add_index :sessions, %i[user_id is_mobile], name: 'index_sessions_active_mobile',
              where: 'expired_at IS NULL AND is_mobile = TRUE'
  end
end
