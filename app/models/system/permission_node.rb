class System::PermissionNode < ApplicationRecord
  acts_as_tenant :business
  has_paper_trail skip: %i[encoded_key unique_id]

  multisearchable against: [ :encoded_key, :unique_id ]

  belongs_to :business, class_name: "System::Business"
  belongs_to :parent, class_name: "System::PermissionNode", optional: true, counter_cache: true
  has_many :children, class_name: "System::PermissionNode", foreign_key: "parent_id", dependent: :destroy
  has_many :role_permissions, dependent: :destroy, class_name: "System::PermissionNode"
  has_many :permissions, through: :role_permissions
  has_many :roles, through: :role_permissions

  after_create :update_path
  after_update :update_path

  broadcasts_refreshes

  # @return [ActiveRecord::Relation<Node>]
  # Returns the root nodes (nodes without a parent) within the current tenant.
  def self.roots
    where(parent_id: nil)
  end

  # Updates the materialized path for the node and its descendants within the current tenant.
  def update_path
    new_path = if parent
                 "#{parent.path}/#{id}"
    else
                 id.to_s
    end

    update_columns(path: new_path)

    children.each(&:update_path)
  end

  # @return [Array<Node>]
  # Returns all ancestor nodes of the current node within the current tenant.
  def ancestors
    path.to_s.split("/").reject(&:empty?).map { |id| System::PermissionNode.find(id) }
  rescue ActiveRecord::RecordNotFound
    []
  end

  def get_role_permission(role)
    System::RolePermission.where(role: role, permission_node: self)
  end
end
