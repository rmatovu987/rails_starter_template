class Settings::UserRole < ApplicationRecord
  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id]

  multisearchable against: [ :encoded_key, :unique_id ]

  belongs_to :user
  belongs_to :role, class_name: "Settings::Role"
  belongs_to :business, class_name: "System::Business"

  broadcasts_refreshes
end
