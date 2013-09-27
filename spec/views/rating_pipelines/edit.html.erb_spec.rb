require 'spec_helper'

describe "rating_pipelines/edit" do
  before(:each) do
    @rating_pipeline = assign(:rating_pipeline, stub_model(RatingPipeline))
  end

  it "renders the edit rating_pipeline form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", rating_pipeline_path(@rating_pipeline), "post" do
    end
  end
end
