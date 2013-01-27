require 'spec_helper'

describe "wineries/edit" do
  before(:each) do
    @winery = assign(:winery, stub_model(Winery))
  end

  it "renders the edit winery form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => wineries_path(@winery), :method => "post" do
    end
  end
end
