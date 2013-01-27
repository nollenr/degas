require "spec_helper"

describe WineriesController do
  describe "routing" do

    it "routes to #index" do
      get("/wineries").should route_to("wineries#index")
    end

    it "routes to #new" do
      get("/wineries/new").should route_to("wineries#new")
    end

    it "routes to #show" do
      get("/wineries/1").should route_to("wineries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/wineries/1/edit").should route_to("wineries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/wineries").should route_to("wineries#create")
    end

    it "routes to #update" do
      put("/wineries/1").should route_to("wineries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/wineries/1").should route_to("wineries#destroy", :id => "1")
    end

  end
end
