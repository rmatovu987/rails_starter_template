class Settings::Role < ApplicationRecord
  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id]

  multisearchable against: [ :encoded_key, :unique_id, :name ]

  belongs_to :business, class_name: "System::Business"

  has_many :role_permissions, dependent: :destroy, class_name: "System::RolePermission"
  has_many :permissions, through: :role_permissions, class_name: "System::Permission"
  has_many :permission_nodes, through: :role_permissions, class_name: "System::PermissionNode"
  has_and_belongs_to_many :users, class_name: "User",
                          join_table: "user_roles"

  enum :status, { pending: 0, active: 1, inactive: 2, deactivated: 3 }, default: :pending, validates: true

  validates :name, presence: true, uniqueness: { scope: :business_id }
  validates :description, presence: true

  broadcasts_refreshes

  # @return [Array<Permission>]
  # Returns all unique permissions associated with this role within the current tenant.
  def all_permissions
    permissions.distinct
  end
end
