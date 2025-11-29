require 'rails_helper'

RSpec.describe "system/businesses/edit", type: :view do
  let(:system_business) {
    System::Business.create!(
      name: "MyString",
      encoded_key: "MyString",
      unique_id: "MyString",
      time_format: "MyString",
      datetime_format: "MyString"
    )
  }

  before(:each) do
    assign(:system_business, system_business)
  end

  it "renders the edit system_business form" do
    render

    assert_select "form[action=?][method=?]", system_business_path(system_business), "post" do
      assert_select "input[name=?]", "system_business[name]"

      assert_select "input[name=?]", "system_business[encoded_key]"

      assert_select "input[name=?]", "system_business[unique_id]"

      assert_select "input[name=?]", "system_business[time_format]"

      assert_select "input[name=?]", "system_business[datetime_format]"
    end
  end
end
