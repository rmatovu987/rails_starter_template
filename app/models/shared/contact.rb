class Shared::Contact < ApplicationRecord
  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id]

  multisearchable against: [ :encoded_key, :unique_id ]

  belongs_to :business, class_name: "System::Business"
  belongs_to :customizable, polymorphic: true

  after_initialize :set_defaults

  def get_primary_email
    primary_email.present? ? primary_email : "-"
  end

  def get_secondary_email
    secondary_email.present? ? secondary_email : "-"
  end

  def get_primary_phone_number
    primary_phone_number.present? ? primary_phone_number : "-"
  end

  def get_secondary_phone_number
    secondary_phone_number.present? ? secondary_phone_number : "-"
  end

  private

  def set_defaults
    self.primary_email ||= ""
    self.secondary_email ||= ""
    self.primary_phone_number ||= ""
    self.secondary_phone_number ||= ""
  end
end
