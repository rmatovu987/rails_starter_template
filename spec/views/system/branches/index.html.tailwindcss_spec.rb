require 'rails_helper'

RSpec.describe "system/branches/index", type: :view do
  before(:each) do
    assign(:system_branches, [
      System::Branch.create!(
        name: "Name",
        encoded_key: "Encoded Key",
        unique_id: "Unique",
        isMain: false,
        status: 2,
        business: nil
      ),
      System::Branch.create!(
        name: "Name",
        encoded_key: "Encoded Key",
        unique_id: "Unique",
        isMain: false,
        status: 2,
        business: nil
      )
    ])
  end

  it "renders a list of system/branches" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Encoded Key".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Unique".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
