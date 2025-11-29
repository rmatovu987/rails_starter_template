require 'rails_helper'

RSpec.describe "system/branches/edit", type: :view do
  let(:system_branch) {
    System::Branch.create!(
      name: "MyString",
      encoded_key: "MyString",
      unique_id: "MyString",
      isMain: false,
      status: 1,
      business: nil
    )
  }

  before(:each) do
    assign(:system_branch, system_branch)
  end

  it "renders the edit system_branch form" do
    render

    assert_select "form[action=?][method=?]", system_branch_path(system_branch), "post" do
      assert_select "input[name=?]", "system_branch[name]"

      assert_select "input[name=?]", "system_branch[encoded_key]"

      assert_select "input[name=?]", "system_branch[unique_id]"

      assert_select "input[name=?]", "system_branch[isMain]"

      assert_select "input[name=?]", "system_branch[status]"

      assert_select "input[name=?]", "system_branch[business_id]"
    end
  end
end
