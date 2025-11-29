class Session < ApplicationRecord
  belongs_to :user
  belongs_to :business, class_name: "System::Business"
end
