require "spec_helper"

describe CommentsController do
  describe "routing" do

    it "routes to #create" do
      get("/gists/123/comments").should_not be_routable
      post("/gists/123/comments").should route_to("comments#create", :gist_id => "123")
      put("/gists/123/comments").should_not be_routable
      delete("/gists/123/comments").should_not be_routable
    end

    it "routes to #destroy" do
      get("/gists/123/comments/1").should_not be_routable
      post("/gists/123/comments/1").should_not be_routable
      put("/gists/123/comments/1").should_not be_routable
      delete("/gists/123/comments/1").should route_to("comments#destroy", :gist_id => "123", :id => "1")
    end

  end
end
