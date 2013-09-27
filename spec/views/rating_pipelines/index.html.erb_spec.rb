require 'spec_helper'

describe "rating_pipelines/index" do
  before(:each) do
    assign(:rating_pipelines, [
      stub_model(RatingPipeline),
      stub_model(RatingPipeline)
    ])
  end

  it "renders a list of rating_pipelines" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
