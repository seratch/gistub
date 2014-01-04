# -*- encoding : utf-8 -*-
require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #show" do
      expect(get("/users/1")).to route_to("users#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/users/1/edit")).to route_to("users#edit", :id => "1")
    end

    it "routes to #update" do
      expect(put("/users/1")).to route_to("users#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/users/1")).to route_to("users#destroy", :id => "1")
    end

  end
end
