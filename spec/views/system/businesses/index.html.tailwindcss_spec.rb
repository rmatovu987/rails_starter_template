require 'rails_helper'

RSpec.describe "system/businesses/index", type: :view do
  before(:each) do
    assign(:system_businesses, [
      System::Business.create!(
        name: "Name",
        encoded_key: "Encoded Key",
        unique_id: "Unique",
        time_format: "Time Format",
        datetime_format: "Datetime Format"
      ),
      System::Business.create!(
        name: "Name",
        encoded_key: "Encoded Key",
        unique_id: "Unique",
        time_format: "Time Format",
        datetime_format: "Datetime Format"
      )
    ])
  end

  it "renders a list of system/businesses" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Encoded Key".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Unique".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Time Format".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Datetime Format".to_s), count: 2
  end
end
