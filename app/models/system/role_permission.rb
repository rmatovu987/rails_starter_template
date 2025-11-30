class System::RolePermission < ApplicationRecord
  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id]

  multisearchable against: [ :encoded_key, :unique_id ]

  belongs_to :business, class_name: "System::Business"
  belongs_to :role, class_name: "Settings::Role"
  belongs_to :permission, class_name: "System::Permission"
  belongs_to :permission_node, class_name: "System::PermissionNode"

  validates :can_access, inclusion: { in: [ true, false ] }

  broadcasts_refreshes
end
