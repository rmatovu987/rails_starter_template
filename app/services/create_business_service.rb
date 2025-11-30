class CreateBusinessService
  def initialize(business_name, domain)
    @business_name = business_name
    @domain = domain
  end

  def call
    create_business
    create_permissions
    create_system_permission_nodes
    create_settings_permission_nodes
    create_main_branch
    create_role
    create_admin_user
  end

  private

  def create_permissions
    PermissionNames.constants.each do |constant_name_symbol|
      value = PermissionNames.const_get(constant_name_symbol)
      System::Permission.find_or_create_by(name: value, business_id: @business.id) do |permission|
        permission.description = "Allows the user to #{value.downcase} records"
        permission.business = @business
      end
    end
  end

  def create_system_permission_nodes
    system = System::PermissionNode.find_or_create_by(name: NodeNames::SYSTEM,
                                                                  business_id: @business.id) do |node|
      node.path = "/system"
      node.parent_id = nil
      node.is_model = false
      node.business = @business
    end

    nodes = [ NodeNames::AUDIT_LOGS, NodeNames::PERMISSIONS, NodeNames::PERMISSION_NODES ]
    nodes.each do |node_name|
      path = case node_name
             when NodeNames::AUDIT_LOGS
               "/system/audit_trails"
             else
               "/system/#{node_name}"
             end
      System::PermissionNode.find_or_create_by(name: node_name,
                                                         business_id: @business.id) do |node|
        node.path = path
        node.parent_id = system.id
        node.is_model = true
        node.business = @business
      end
    end
  end

  def create_settings_permission_nodes
    settings = System::PermissionNode.find_or_create_by(name: NodeNames::SETTINGS,
                                                                  business_id: @business.id) do |node|
      node.path = "/settings"
      node.parent_id = nil
      node.is_model = false
      node.business = @business
    end

    nodes = [ NodeNames::BRANCHES, NodeNames::ROLES ]
    nodes.each do |node_name|
      System::PermissionNode.find_or_create_by(name: node_name,
                                                         business_id: @business.id) do |node|
        node.path = "/system/#{node_name}"
        node.parent_id = settings.id
        node.is_model = true
        node.business = @business
      end
    end
    end

  def create_business
    @business = System::Business.find_or_create_by(name: @business_name)
    puts "Business errors: #{@business.errors.full_messages}" if @business.errors.any?
    ActsAsTenant.current_tenant = @business
  end

  def create_main_branch
    @main_branch = Settings::Branch.find_or_create_by(name: "Headquarter", business_id: @business.id) do |branch|
      branch.isMain = true
      branch.code = "HQ"
      branch.status = "active"
      branch.business = @business
    end
    puts "Branch errors: #{@main_branch.errors.full_messages}" if @main_branch.errors.any?
  end

  def create_admin_user
    @admin_user = User.find_or_create_by(email_address: "admin@#{@domain}", business_id: @business.id) do |user|
      user.firstname = "Super"
      user.lastname = "Administrator"
      user.status = "active"
      user.password = "testing123"
      user.time_zone = "Nairobi"
      user.password_confirmation = "testing123"
      user.super_user = true
      user.assigned_branch_id = @main_branch.id
    end
    puts "User errors: #{@admin_user.errors.full_messages}" if @admin_user.errors.any?

    user_role = Settings::UserRole.find_or_create_by(user_id: @admin_user.id, role_id: @role.id, business_id: @business.id)
    puts "UserRole errors: #{user_role.errors.full_messages}" if user_role.errors.any?

    user_branch = Settings::UserBranch.find_or_create_by(user_id: @admin_user.id, branch_id: @main_branch.id, business_id: @business.id)
    puts "UserBranch errors: #{user_branch.errors.full_messages}" if user_branch.errors.any?
  end

  def create_role
    @role = Settings::CreateRole.new.call("Super Admin", "Super Administrator", @business)
    @role.update(status: "active")
    @role.role_permissions.update_all(can_access: true)
    puts "Role errors: #{@role.errors.full_messages}" if @role.errors.any?
  end
end
