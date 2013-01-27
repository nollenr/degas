require 'spec_helper'

describe "wineries/index" do
  before(:each) do
    assign(:wineries, [
      stub_model(Winery),
      stub_model(Winery)
    ])
  end

  it "renders a list of wineries" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
