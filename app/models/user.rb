class User < ApplicationRecord
  # For the current_password validation (virtual attribute)
  attr_accessor :current_password

  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id avatar last_password_change_at]

  multisearchable against: [ :encoded_key, :unique_id, :firstname, :lastname, :email_address ]

  has_secure_password
  has_many :sessions, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  validates :avatar, content_type: ACCEPTED_IMAGE_TYPES, size: { less_than: 500.kilobytes }

  before_validation :check_time_zone

  validates :email_address,
            presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ },
            uniqueness: { scope: :business_id, message: "is already taken!", case_sensitive: false }
  validates :time_zone, presence: true
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Custom validation for current_password when password is being updated
  validate :password_not_same_as_current, if: :password_being_changed?

  belongs_to :assigned_branch, class_name: "Settings::Branch"
  belongs_to :business, class_name: "System::Business"

  enum :status, { inactive: 0, active: 1, suspended: 2, terminated: 3 }, default: :active, validate: true

  broadcasts_refreshes

  def full_name
    "#{self.firstname} #{self.lastname}"
  end

  def check_time_zone
    self.time_zone ||= "UTC"
  end

  private

  def password_not_same_as_current
    return unless persisted?
    return if sessions.empty?
    return unless password.present?

    if password_digest_was.present? && BCrypt::Password.new(password_digest_was).is_password?(password)
      errors.add(:password, "cannot be the same as your current password")
      errors.add(:password_confirmation, "cannot be the same as your current password")
    end
  rescue BCrypt::Errors::InvalidHash
    errors.add(:password, "could not be validated against your current password due to a system error.")
    errors.add(:password_confirmation, "could not be validated against your current password due to a system error.")
  end

  def password_being_changed?
    password.present?
  end
end
