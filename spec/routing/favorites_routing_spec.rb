# -*- encoding : utf-8 -*-
require "spec_helper"

describe FavoritesController do
  describe "routing" do

    it "routes to #create" do
      expect(get("/gists/123/favorites")).not_to be_routable
      expect(post("/gists/123/favorites")).to route_to("favorites#create", :gist_id => "123")
      expect(put("/gists/123/favorites")).not_to be_routable
      expect(delete("/gists/123/favorites")).not_to be_routable
    end

    it "routes to #destroy" do
      expect(get("/gists/123/favorites/1")).not_to be_routable
      expect(post("/gists/123/favorites/1")).not_to be_routable
      expect(put("/gists/123/favorites/1")).not_to be_routable
      expect(delete("/gists/123/favorites/1")).to route_to("favorites#destroy", :gist_id => "123", :id => "1")
    end

  end
end
