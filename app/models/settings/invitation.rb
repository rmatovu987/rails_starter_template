class Settings::Invitation < ApplicationRecord
  EXPIRY_DAYS = 7
  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id]

  before_validation :check_time_zone

  belongs_to :assigned_branch, class_name: "Settings::Branch"
  belongs_to :business, class_name: "System::Business"
  belongs_to :inviter, class_name: "User"

  enum :status, { pending: 0, accepted: 2 }, default: :pending, validates: true

  multisearchable against: [ :encoded_key, :unique_id, :firstname, :lastname, :email_address ]

  validates :firstname, :lastname, :email_address, :time_zone, presence: true

  validates :email_address,
            presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ },
            uniqueness: { scope: :business_id, message: "is already invited!", case_sensitive: false }

  broadcasts_refreshes

  generates_token_for :invitation, expires_in: EXPIRY_DAYS.days do
    accepted_at
  end

  def check_time_zone
    self.time_zone ||= "UTC"
  end
end
