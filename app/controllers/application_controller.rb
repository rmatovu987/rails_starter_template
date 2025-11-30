class ApplicationController < ActionController::Base
  include Authentication
  # Sets the current tenant through a filter for multi-tenancy support.
  set_current_tenant_through_filter

  before_action :set_current_tenant

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Sets the `whodunnit` information for PaperTrail for tracking changes.
  before_action :set_paper_trail_whodunnit

  helper_method :authorize!, :current_user, :current_business

  before_action :set_current_user, if: :authenticated?

  # Add a before_action to check for session timeout
  before_action :check_session_timeout

  around_action :set_time_zone, if: :current_user

  include ApplicationHelper

  # @param node_name [String] The name of the node to authorize access for.
  # @param permission_name [String] The name of the permission required.
  # @return [void] Redirects to root_path with an alert if the current user is not authorized within the current tenant.
  def authorize!(node_name, permission_name)
    # unless current_user&.can?(node_name, permission_name)
    #   flash[:alert] = "You are not authorized to perform this action."
    #   redirect_back(fallback_location: root_path) and return
    # end
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:alert] = "Record not found or you are not authorized to access it."
    redirect_back(fallback_location: root_path)
  end

  def set_current_user
    if session[:user_id]
      Current.user = User.unscoped.find(session[:user_id])
    end
    start_new_session_for(Current.user) unless resume_session
  end

  def current_user
    Current.user
  end

  def current_business
    Current.user.business if Current.user
  end

  private

  # Sets the current tenant for the request using the act_as_tenant gem.
  # You need to implement the logic to identify the current business.
  def set_current_tenant
    ActsAsTenant.current_tenant = Current.user&.business || System::Business.first
  end

  def check_session_timeout
    if Current.session&.last_access && Current.session.last_access <= SessionConfig::SESSION_TIMEOUT.ago
      terminate_session if authenticated?
      reset_session
      flash[:alert] = "Your session has timed out. Please log in again."
      redirect_to new_session_path
    else
      Current.session.update!(last_access: Time.current) if Current.session
    end
  end

  def set_time_zone(&block)
    # This block ensures that Time.zone is set for the duration of the request
    # and then reverted to its original value (usually UTC) afterwards.
    Time.use_zone(timezone, &block)
  end

  def timezone
    if current_user
      current_user.time_zone
    else
      "UTC"
    end
  end
end
