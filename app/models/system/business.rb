class System::Business < ApplicationRecord
  # You might want to set defaults
  after_initialize :set_default_formats, if: :new_record?

  broadcasts_refreshes

  validates :time_format, :datetime_format, presence: true

  private

  def set_default_formats
    self.time_format ||= "%I:%M %p %Z" # e.g., "03:00 PM CEST"
    self.datetime_format ||= "%B %d, %Y %I:%M %p %Z" # e.g., "July 24, 2025 03:00 PM CEST"
  end
end
