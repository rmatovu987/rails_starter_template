class System::Permission < ApplicationRecord
  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id]

  multisearchable against: [ :encoded_key, :unique_id ]

  belongs_to :business, class_name: "System::Business"
  has_many :role_permissions, dependent: :destroy, class_name: "System::RolePermission"
  has_many :roles, through: :role_permissions, class_name: "Organization::RolePermission"
  has_many :permission_nodes, through: :role_permissions, class_name: "System::PermissionNode"

  broadcasts_refreshes
end
