require 'spec_helper'

describe "wineries/show" do
  before(:each) do
    @winery = assign(:winery, stub_model(Winery))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
