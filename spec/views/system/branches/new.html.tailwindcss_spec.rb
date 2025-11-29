require 'rails_helper'

RSpec.describe "system/branches/new", type: :view do
  before(:each) do
    assign(:system_branch, System::Branch.new(
      name: "MyString",
      encoded_key: "MyString",
      unique_id: "MyString",
      isMain: false,
      status: 1,
      business: nil
    ))
  end

  it "renders new system_branch form" do
    render

    assert_select "form[action=?][method=?]", system_branches_path, "post" do
      assert_select "input[name=?]", "system_branch[name]"

      assert_select "input[name=?]", "system_branch[encoded_key]"

      assert_select "input[name=?]", "system_branch[unique_id]"

      assert_select "input[name=?]", "system_branch[isMain]"

      assert_select "input[name=?]", "system_branch[status]"

      assert_select "input[name=?]", "system_branch[business_id]"
    end
  end
end
