require "spec_helper"

describe FavoritesController do
  describe "routing" do

    it "routes to #create" do
      get("/gists/123/favorites").should_not be_routable
      post("/gists/123/favorites").should route_to("favorites#create", :gist_id => "123")
      put("/gists/123/favorites").should_not be_routable
      delete("/gists/123/favorites").should_not be_routable
    end

    it "routes to #destroy" do
      get("/gists/123/favorites/1").should_not be_routable
      post("/gists/123/favorites/1").should_not be_routable
      put("/gists/123/favorites/1").should_not be_routable
      delete("/gists/123/favorites/1").should route_to("favorites#destroy", :gist_id => "123", :id => "1")
    end

  end
end
