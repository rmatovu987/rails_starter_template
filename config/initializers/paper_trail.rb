# frozen_string_literal: true

module PaperTrail
  # Paper trail
  class Version < ActiveRecord::Base
    self.table_name = :versions

    # Define the association to the user who made the change
    # The foreign_key is 'whodunnit' because that's where PaperTrail stores the user ID
    # optional: true is added in case some versions don't have a whodunnit (e.g., initial creates by the system)
    belongs_to :user, class_name: "System::User", foreign_key: :whodunnit, optional: true

    before_create :set_business_id

    # NEW: Add a before_save callback to prevent saving if it's an update with no changes
    before_save :skip_if_empty_update

    def self.search(params)
      if params[:query].blank?
        all
      else
        # Join with the user table for searching on full name
        # Use LEFT JOIN to include versions without a whodunnit
        joins("LEFT JOIN settings_organization_users ON versions.whodunnit = settings_organization_users.id")
          .where("CONCAT_WS('|', LOWER(versions.event), LOWER(versions.item_type), LOWER(COALESCE(settings_organization_users.firstname, ''), COALESCE(settings_organization_users.lastname, '')), LOWER(versions.whodunnit)) LIKE ?",
                 "%#{sanitize_sql_like(params[:query].downcase)}%")
      end
    end

    def changeset_has_key?(key)
      changeset.key?(key)
    end

    def model
      item_type.demodulize.underscore.titleize
    end

    # Override PaperTrail's default whodunnit method to return the user object
    # This is not strictly necessary for the N+1 fix if you use the `user` association directly,
    # but it can be helpful for consistency if you were using `version.whodunnit` to get the user object previously.
    def whodunnit
      user
    end

    private

    # Callback to prevent saving a version if it's an 'update' event with no actual object changes.
    # This avoids cluttering the versions table with irrelevant entries.
    def skip_if_empty_update
      # Only apply this logic to 'update' events
      if self.event == "update"
        # `object_changes` is a Hash. It can be nil if no changes were logged,
        # or empty if there were changes but they resulted in the same value.
        # PaperTrail typically sets it to an empty hash {} if no tracked attributes changed.
        if self.object_changes.blank?
          # Halt the callback chain, preventing the version from being saved.
          throw :abort
        end
      end
    end


    def set_business_id
      if ActsAsTenant.current_tenant
        self.business_id = ActsAsTenant.current_tenant.id
      end

      if self.item_type == "Session"
        self.whodunnit = Session.find(self.item_id).user_id
      end

      if self.user
        self.full_name = "#{self.user.firstname} #{self.user.lastname}"
      elsif self.whodunnit.present?
        # Fallback if user association is not loaded, though with includes this path should be rare
        fetched_user = System::User.find_by(id: self.whodunnit)
        self.full_name = fetched_user ? "#{fetched_user.firstname} #{fetched_user.lastname}" : "System"
      else
        self.full_name = "System"
      end

      # Read from PaperTrail.request.controller_info
      # This will be available if set in a controller before the version is created
      self.is_api = PaperTrail.request.controller_info && PaperTrail.request.controller_info[:is_api] || false
    end
  end
end
