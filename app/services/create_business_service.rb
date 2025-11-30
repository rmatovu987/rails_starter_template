class CreateBusinessService
  def initialize(business_name, domain)
    @business_name = business_name
    @domain = domain
  end

  def call
    create_business
    create_main_branch
    create_admin_user
  end

  private

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
  end
end
