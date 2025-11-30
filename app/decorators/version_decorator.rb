# app/decorators/version_decorator.rb
class VersionDecorator < SimpleDelegator
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ApplicationHelper # Include your custom helper if needed

  def initialize(version)
    super
  end

  def decorated_event
    case event
    when "destroy"
      "#{event.humanize}ed #{model}"
    when "attach_profile"
      "Attached Profile Photo"
    when "detach_profile"
      "Deleted Profile Photo"
    else
      "#{event.humanize}d #{model}"
    end
  end

  def decorated_user
    "#{full_name}#{' (API)' if is_api}"
  end

  def decorated_changes
    changes_html = ""
    changeset.each do |field, value|
      # Skip ignored fields
      next if [ "updated_at", "created_at", "business_id", "id", "encrypted_password" ].include?(field)
      next if field.downcase.include?("customizable") || field.downcase.include?("ratable") || field.downcase.include?("cft_group") || field.downcase.include?("cf_group") || field.downcase.include?("auditable") || field.downcase.include?("source") || field.downcase.include?("recipient")

      # Handle special events and fields
      if field == "password_digest" && event == "update"
        changes_html << "Updated Password<br/>"
      elsif event == "update"
        if field == "sign_in_count"
          changes_html << "Logged in<br/>"
        elsif field.to_s.include?("_id") && field != "unique_id" && field != "field_identifier"
          changes_html << "Changed <strong>#{field.humanize}</strong> from <em>#{generate_audit_view_link_for_change(field, value[0], type: item_type)}</em> to <em>#{generate_audit_view_link_for_change(field, value[1], type: item_type)}</em><br/>"
        elsif field.to_s.include?("date")
          changes_html << "Changed <strong>#{field.humanize}</strong> from <em>#{format_time(humanize_label(value[0])) || '-'}</em> to <em>#{format_time(humanize_label(value[1]))}</em><br/>"
        else
          changes_html << "Changed <strong>#{field.humanize}</strong> from <em>#{humanize_label(value[0])}</em> to <em>#{humanize_label(value[1])}</em><br/>"
        end
      elsif event == "create"
        next if field == "password_digest"
        if field.to_s.include?("_id") && field != "unique_id" && field != "field_identifier"
          changes_html << "<strong>#{field.humanize}</strong> <em>#{generate_audit_view_link_for_change(field, value[1], type: item_type)}</em><br/>"
        else
          changes_html << "<strong>#{field.humanize}</strong> <em>#{humanize_label(value[1])}</em><br/>"
        end
      elsif event == "destroy"
        next if field == "password_digest"
        if field.to_s.include?("_id") && field != "unique_id" && field != "field_identifier"
          changes_html << "<strong>#{field.humanize}</strong> <em>#{generate_audit_view_link_for_change(field, value[0], type: item_type)}</em><br/>"
        else
          changes_html << "<strong>#{field.humanize}</strong> <em>#{humanize_label(value[0])}</em><br/>"
        end
      elsif event == "attach_profile"
        changes_html << "Attached Profile Picture<br/>"
      elsif event == "detach_profile"
        changes_html << "Removed Profile Picture<br/>"
      else
        changes_html << "#{field}: #{humanize_label(value)}<br/>"
      end
    end
    changes_html.html_safe
  end

  def decorated_record_id
    generate_audit_view_link(item_type, item_id)
  end
end
