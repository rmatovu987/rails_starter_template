require 'rails_helper'

RSpec.describe "system/businesses/new", type: :view do
  before(:each) do
    assign(:system_business, System::Business.new(
      name: "MyString",
      encoded_key: "MyString",
      unique_id: "MyString",
      time_format: "MyString",
      datetime_format: "MyString"
    ))
  end

  it "renders new system_business form" do
    render

    assert_select "form[action=?][method=?]", system_businesses_path, "post" do
      assert_select "input[name=?]", "system_business[name]"

      assert_select "input[name=?]", "system_business[encoded_key]"

      assert_select "input[name=?]", "system_business[unique_id]"

      assert_select "input[name=?]", "system_business[time_format]"

      assert_select "input[name=?]", "system_business[datetime_format]"
    end
  end
end
