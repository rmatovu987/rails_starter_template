require 'rails_helper'

RSpec.describe "system/branches/show", type: :view do
  before(:each) do
    assign(:system_branch, Settings::Branch.create!(
      name: "Name",
      encoded_key: "Encoded Key",
      unique_id: "Unique",
      isMain: false,
      status: 2,
      business: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Encoded Key/)
    expect(rendered).to match(/Unique/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
