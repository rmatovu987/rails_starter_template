class Shared::Address < ApplicationRecord
  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id]

  multisearchable against: [ :encoded_key, :unique_id ]

  belongs_to :business, class_name: "System::Business"
  belongs_to :customizable, polymorphic: true

  after_initialize :set_defaults

  def get_street_name
    street_name.present? ? street_name : "-"
  end

  def get_city
    city.present? ? city : "-"
  end

  def get_region
    region.present? ? region : "-"
  end

  def get_country
    country.present? ? country : "-"
  end

  private

  def set_defaults
    self.street_name ||= ""
    self.city ||= ""
    self.region ||= ""
    self.country ||= ""
  end
end
