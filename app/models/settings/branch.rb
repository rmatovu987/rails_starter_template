class Settings::Branch < ApplicationRecord
  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id]

  multisearchable against: [ :encoded_key, :unique_id, :name ]

  belongs_to :business, class_name: "System::Business"
  has_and_belongs_to_many :users, class_name: "User", join_table: "user_branches"

  enum :status, { pending: 0, active: 1, closed: 2 }, default: :pending, validate: true

  validates :name, presence: true

  broadcasts_refreshes
end
