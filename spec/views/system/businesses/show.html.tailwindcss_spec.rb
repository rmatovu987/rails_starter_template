require 'rails_helper'

RSpec.describe "system/businesses/show", type: :view do
  before(:each) do
    assign(:system_business, System::Business.create!(
      name: "Name",
      encoded_key: "Encoded Key",
      unique_id: "Unique",
      time_format: "Time Format",
      datetime_format: "Datetime Format"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Encoded Key/)
    expect(rendered).to match(/Unique/)
    expect(rendered).to match(/Time Format/)
    expect(rendered).to match(/Datetime Format/)
  end
end
