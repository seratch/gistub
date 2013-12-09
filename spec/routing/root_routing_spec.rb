# -*- encoding : utf-8 -*-
require "spec_helper"

describe RootController do
  describe "routing" do

    it "routes to root" do
      expect(get("/")).to route_to("root#index")
      expect(post("/")).to route_to("root#index")
      expect(put("/")).to route_to("root#index")
      expect(delete("/")).to route_to("root#index")
    end

  end
end
