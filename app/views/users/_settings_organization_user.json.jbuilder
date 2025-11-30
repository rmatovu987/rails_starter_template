json.extract! user, :id, :firstname, :lastname, :email, :status, :unique_id, :encoded_key, :super_user, :contact_id, :address_id, :business_id, :created_at, :updated_at
json.url user_url(user, format: :json)
