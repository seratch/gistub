require "spec_helper"

describe RootController do
  describe "routing" do

    it "routes to root" do
      get("/").should route_to("root#index")
      post("/").should route_to("root#index")
      put("/").should route_to("root#index")
      delete("/").should route_to("root#index")
    end

  end
end
