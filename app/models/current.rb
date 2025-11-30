class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true

  def user=(user)
    self.session ||= OpenStruct.new # Or initialize with your actual session object if needed
    self.session.user = user

    if self.session.user.nil? && self.session.user_id.present?
      self.session.user = User.find(self.session.user_id)
    end
  end
end
