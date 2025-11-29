FactoryBot.define do
  factory :system_branch, class: 'System::Branch' do
    name { "MyString" }
    encoded_key { "MyString" }
    unique_id { "MyString" }
    isMain { false }
    status { 1 }
    business { nil }
  end
end
