class System::AuditTrailsController < ApplicationController
  def index
    authorize! NodeNames::AUDIT_LOGS, PermissionNames::VIEW_ALL
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Audit Trails", url: system_audit_trails_path }
    ]

    @datatable_columns = [
      { data: "event", name: "event" },
      { data: "record_id", name: "record_id" },
      { data: "actioned_at", name: "actioned_at" },
      { data: "user", name: "user" },
      { data: "changes", name: "changes" }
    ].to_json
    @datatable_order = [ [ 2, "desc" ] ].to_json

    versions = PaperTrail::Version.all
    total_records = versions.count

    if params[:query].present?
      versions = versions.search(params)
    end

    filtered_records = versions.count

    versions = versions.order(created_at: :desc)

    page_length = params[:length].to_i > 0 ? params[:length].to_i : 10 # Default to 10 if not provided
    start_offset = params[:start].to_i
    versions = versions.offset(start_offset).limit(page_length)

    data = versions.includes([ :item ]).map do |version|
      decorated_version = VersionDecorator.new(version)
      {
        event: decorated_version.decorated_event,
        record_id: decorated_version.decorated_record_id,
        actioned_at: format_time(decorated_version.created_at),
        user: decorated_version.decorated_user,
        changes: decorated_version.decorated_changes
      }
    end

    response_data = {
      draw: params[:draw].to_i, # Echo back the draw parameter
      recordsTotal: total_records, # Total records before filtering
      recordsFiltered: filtered_records, # Total records after filtering
      data: data # The formatted data for the current page
    }

    respond_to do |format|
      format.html
      format.json { render json: response_data }
    end
  end
end
