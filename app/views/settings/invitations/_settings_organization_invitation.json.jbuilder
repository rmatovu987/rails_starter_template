json.extract! settings_organization_invitation, :id, :firstname, :lastname, :email_address, :inviter_id, :accepted_at, :business_id, :created_at, :updated_at
json.url settings_organization_invitation_url(settings_organization_invitation, format: :json)
