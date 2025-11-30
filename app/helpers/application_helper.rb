# Defines a fixed sample time for demonstrating format outputs.
# This is crucial so that the examples in the dropdown are consistent
# and make sense regardless of when the form is rendered.
SAMPLE_TIME = Time.zone.parse("1996-06-23 7:30:00") # July 23, 1996, 7:30:00 AM in current Time.zone

module ApplicationHelper
  def evaluate_version(version)
    return false if version.nil? || version.item.nil?

    count = version.changeset.size
    version.changeset.each do |field, value|
      count -= 1 if field == "updated_at"
      count -= 1 if field == "created_at"
      count -= 1 if field == "business_id"
      count -= 1 if field == "id"
      count -= 1 if field == "lock_version"
      count -= 1 if field == "encrypted_password"
      count -= 1 if field.downcase.include? "customizable"
      count -= 1 if field.downcase.include? "ratable"
      count -= 1 if field.downcase.include? "cft_group"
      count -= 1 if field.downcase.include? "cf_group"
      count -= 1 if field.downcase.include? "auditable"
      count -= 1 if field.downcase.include? "source"
      count -= 1 if field.downcase.include? "recipient"
      count -= 1 if field.downcase.include?("password_digest") && version.event != "update"
    end
    count.positive?
  end

  def dependent_versions(*objects)
    objects.compact.flat_map { |obj| obj.versions.includes([ :item ]) || [] }
  end

  # Determines if a route is active based on the current request path.
  #
  # @param route [String] The route to check.
  # @return [String] 'active' if the route matches the current path, otherwise `nil`.
  def active?(route)
    if route.empty?
      "bg-gray-100" if request.path.to_s == "/"
    elsif request.path.to_s.start_with?(route)
      "bg-gray-100"
    end
  end

  def humanize_label(label)
    if label.is_a?(TrueClass) || label.is_a?(FalseClass)
      label ? "Yes" : "No"
    else
      label.to_s.humanize
    end
  end

  # Returns an array of arrays suitable for a Rails select helper,
  # providing options for various time formats.
  # Each inner array is [display_name, format_string].
  def time_format_options
    [
      # Common 12-hour formats
      [ SAMPLE_TIME.strftime("%I:%M %p"), "%I:%M %p" ], # 03:30 PM
      [ SAMPLE_TIME.strftime("%I:%M %p %Z"), "%I:%M %p %Z" ], # 03:30 PM CEST
      [ SAMPLE_TIME.strftime("%l:%M %P"), "%l:%M %P" ], # 3:30 pm (no leading zero, lowercase AM/PM)
      [ SAMPLE_TIME.strftime("%H:%M"), "%H:%M" ], # 15:30 (24-hour format)
      [ SAMPLE_TIME.strftime("%H:%M:%S"), "%H:%M:%S" ], # 15:30:00 (24-hour with seconds)
      [ SAMPLE_TIME.strftime("%k:%M"), "%k:%M" ] # 15:30 (24-hour, no leading zero for hour)
    ]
  end

  # Returns an array of arrays suitable for a Rails select helper,
  # providing options for various datetime formats.
  # Each inner array is [display_name, format_string].
  def datetime_format_options
    [
      # Standard combined formats
      [ SAMPLE_TIME.strftime("%Y-%m-%d %H:%M:%S"), "%Y-%m-%d %H:%M:%S" ], # 2025-07-24 15:30:00
      [ SAMPLE_TIME.strftime("%m/%d/%Y %I:%M %p"), "%m/%d/%Y %I:%M %p" ], # 07/24/2025 03:30 PM
      [ SAMPLE_TIME.strftime("%d-%m-%Y %H:%M"), "%d-%m-%Y %H:%M" ], # 24-07-2025 15:30

      # More verbose/friendly formats
      [ SAMPLE_TIME.strftime("%B %d, %Y %I:%M %p"), "%B %d, %Y %I:%M %p" ], # July 24, 2025 03:30 PM
      [ SAMPLE_TIME.strftime("%B %d, %Y %I:%M %p %Z"), "%B %d, %Y %I:%M %p %Z" ], # July 24, 2025 03:30 PM CEST
      [ SAMPLE_TIME.strftime("%A, %B %d, %Y %I:%M %p"), "%A, %B %d, %Y %I:%M %p" ], # Thursday, July 24, 2025 03:30 PM

      # ISO 8601 compatible (highly recommended for APIs/consistency)
      [ SAMPLE_TIME.iso8601, "%Y-%m-%dT%H:%M:%S%Z" ], # 2025-07-24T15:30:00+02:00 (note: Ruby's %Z can vary)
      [ SAMPLE_TIME.utc.iso8601, "%Y-%m-%dT%H:%M:%S.000Z" ], # 2025-07-24T13:30:00.000Z (UTC for consistency)

      # Date only formats (useful if you allow business to pick separate date/time components)
      [ SAMPLE_TIME.strftime("%Y-%m-%d"), "%Y-%m-%d" ], # 2025-07-24
      [ SAMPLE_TIME.strftime("%m/%d/%Y"), "%m/%d/%Y" ], # 07/24/2025
      [ SAMPLE_TIME.strftime("%d %b %Y"), "%d %b %Y" ] # 24 Jul 2025
    ]
  end

  # Formats a given time object (Date, DateTime, or Time) into a string,
  # converted to the current user's configured timezone.
  #
  # It now checks if a `business` object (assuming `current_business` or similar)
  # is available and uses its `time_format` or `datetime_format`.
  # Falls back to a default if no business or format is specified.
  def format_time(time_object, format = nil)
    return nil if time_object.nil?

    begin
      time_in_user_zone = time_object.in_time_zone

      # Determine the format to use
      used_format = format
      if used_format.nil?
        # Attempt to use the business's configured format
        # You'll need a way to get the current business object here,
        # e.g., `current_business` if you have one, or from the context.
        # For simplicity, assuming a `current_business` helper or
        # that it can be passed in. If not, adjust how you get the business.
        if defined?(current_business) && current_business.present?
          if time_object.is_a?(Date) && !time_object.is_a?(DateTime) && !time_object.is_a?(Time)
            # If it's strictly a Date object, use the datetime format but only display date parts
            # This is a heuristic; you might need separate date_only_format attribute.
            used_format = current_business.datetime_format || "%B %d, %Y"
            # Attempt to strip time components from the format string if only a Date
            used_format = used_format.gsub(/%I|%H|%M|%S|%P|%p|%Z|%z|%L|%N|:/, "").strip
          elsif time_object.is_a?(Time) || time_object.is_a?(DateTime) || time_object.is_a?(ActiveSupport::TimeWithZone)
            used_format = current_business.datetime_format || "%B %d, %Y %I:%M %p %Z"
          else
            # Fallback for unexpected types
            used_format = "%B %d, %Y %I:%M %p %Z"
          end
        else
          # Fallback if no business or format is configured
          used_format = "%B %d, %Y %I:%M %p %Z"
        end
      end

      # If the format is still nil or a symbol, handle I18n formats first
      if used_format.is_a?(Symbol)
        begin
          l(time_in_user_zone, format: used_format)
        rescue I18n::MissingTranslationData
          Rails.logger.warn "I18n time format :#{used_format} not found. Falling back to default strftime."
          time_in_user_zone.strftime("%B %d, %Y %I:%M %p %Z")
        end
      else
        # Assume it's a String format for strftime
        time_in_user_zone.strftime(used_format)
      end
    rescue => e
      Rails.logger.error "Error in `format_time_for_user` helper for object #{time_object.inspect}: #{e.message}"
      time_object.to_s # Fallback to a simple string representation
    end
  end

  # Generates a link to view an audit record for a specific change based on the model and ID.
  #
  # @param model [String] The name of the model or association.
  # @param id [Integer] The ID of the record.
  # @param options [Hash] Additional options for the link (e.g., target).
  # @return [String] The HTML link or the model name if no link can be generated.
  def generate_audit_view_link_for_change(model, id, options = {}, type: nil)
    options[:target] ||= "_blank"
    return "-" if id.nil?

    model_name = case model.to_s
                 when "branch_id", "assigned_branch_id" then "Settings::Branch"
                 when "role_id" then "Settings::Role"
                 when "permission_id" then "System::Permission"
                 when "permission_node_id" then "System::PermissionNode"
                 when "user_id", "inviter_id", "setter_id", "ender_id", "withdrawn_by_id", "approved_by_id", "rejected_by_id",
                   "disbursed_by_id", "closed_by_id", "refunded_by_id", "allocated_by_id" then "User"
                 when "parent_id"
                   if type
                     type
                   end
                 else
                   nil
                 end

    case model
    when "role_permission_id", "session_id", "user_role_id", "user_branch_id"
      "-"
    when "branch_id", "assigned_branch_id"
      link_to(RichLib.encode(id, model_name), settings_branch_path(id), options)
    when "role_id"
      link_to(RichLib.encode(id, model_name), settings_role_path(id), options)
    when "user_id"
      link_to(RichLib.encode(id, model_name), user_path(id), options)
    when "permission_id"
      link_to(RichLib.encode(id, model_name), system_permission_path(id), options)
    when "permission_node_id"
      link_to(RichLib.encode(id, model_name), system_permission_node_path(id), options)
    when "parent_id"
      if model_name == "System::PermissionNode"
        link_to(RichLib.encode(id, model_name), system_permission_node_path(id), options)
      else
        model
      end
    else
      model
    end
  end

  # Generates a link to view an audit record for a specific model and ID.
  #
  # @param model [String] The name of the model.
  # @param id [Integer] The ID of the record.
  # @param options [Hash] Additional options for the link (e.g., target).
  # @return [String] The HTML link or the model name if no link can be generated.
  def generate_audit_view_link(model, id, options = {})
    options[:target] ||= "_blank"

    case model
    when "System::RolePermission", "Session", "Settings::UserRole", "Settings::UserBranch"
      "-"
    when "Settings::Branch"
      link_to(RichLib.encode(id, model), settings_branch_path(id), options)
    when "Settings::Role"
      link_to(RichLib.encode(id, model), settings_role_path(id), options)
    when "User"
      link_to(RichLib.encode(id, model), user_path(id), options)
    when "Settings::System::Permission"
      link_to(RichLib.encode(id, model), system_permission_path(id), options)
    when "Settings::System::PermissionNode"
      link_to(RichLib.encode(id, model), system_permission_node_path(id), options)
    else
      model
    end
  end
end
