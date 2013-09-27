require "spec_helper"

describe RatingPipelinesController do
  describe "routing" do

    it "routes to #index" do
      get("/rating_pipelines").should route_to("rating_pipelines#index")
    end

    it "routes to #new" do
      get("/rating_pipelines/new").should route_to("rating_pipelines#new")
    end

    it "routes to #show" do
      get("/rating_pipelines/1").should route_to("rating_pipelines#show", :id => "1")
    end

    it "routes to #edit" do
      get("/rating_pipelines/1/edit").should route_to("rating_pipelines#edit", :id => "1")
    end

    it "routes to #create" do
      post("/rating_pipelines").should route_to("rating_pipelines#create")
    end

    it "routes to #update" do
      put("/rating_pipelines/1").should route_to("rating_pipelines#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/rating_pipelines/1").should route_to("rating_pipelines#destroy", :id => "1")
    end

  end
end
