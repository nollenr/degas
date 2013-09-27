require 'spec_helper'

describe "rating_pipelines/new" do
  before(:each) do
    assign(:rating_pipeline, stub_model(RatingPipeline).as_new_record)
  end

  it "renders new rating_pipeline form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", rating_pipelines_path, "post" do
    end
  end
end
