require 'spec_helper'

describe "rating_pipelines/show" do
  before(:each) do
    @rating_pipeline = assign(:rating_pipeline, stub_model(RatingPipeline))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
