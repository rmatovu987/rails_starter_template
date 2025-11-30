class Settings::CreateRole
  def call(name, description, business)
    ActiveRecord::Base.transaction do
      role = Settings::Role.find_or_create_by(name: name, business_id: business.id) do |role|
        role.description = description
        role.status = "pending"
        role.business = business
      end

      permission_nodes = System::PermissionNode.where(business_id: business.id)
      permission_nodes.each do |node|
        defaults = if node.is_model
                     [ PermissionNames::CREATE, PermissionNames::UPDATE, PermissionNames::VIEW_DETAILS,
                      PermissionNames::VIEW_ALL, PermissionNames::DELETE ]
        else
                     [ PermissionNames::VIEW_DETAILS ]
        end

        if node.is_model
          if node.name == NodeNames::ROLES
            defaults << PermissionNames::UPDATE_PERMISSIONS
          elsif node.name == NodeNames::BRANCHES
            defaults << PermissionNames::ACTIVATE
            defaults << PermissionNames::CLOSE
          elsif [ NodeNames::AUDIT_LOGS ].include? node.name
            defaults = [ PermissionNames::VIEW_ALL ]
          elsif node.name == NodeNames::USERS
            defaults << PermissionNames::ASSIGN_ROLE
            defaults << PermissionNames::REVOKE_ROLE
            defaults << PermissionNames::ATTACH_BRANCH_TO_USER
            defaults << PermissionNames::DETACH_BRANCH_FROM_USER
            defaults << PermissionNames::GENERATE_USER_TOKEN
          end
        end

        permissions = System::Permission.where(name: defaults, business_id: business.id)
        permissions.each do |permission|
          System::RolePermission.find_or_create_by(role_id: role.id,
                                                             permission_id: permission.id,
                                                             permission_node_id: node.id,
                                                             business_id: business.id) do |r_perm|
            r_perm.can_access = false
          end
        end
      end

      role
    end
  end
end
