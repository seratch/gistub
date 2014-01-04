# -*- encoding : utf-8 -*-
require "spec_helper"

describe SessionsController do
  describe "routing" do

    it "routes to #start" do
      expect(get("/signin")).to route_to("sessions#start")
    end

    it "routes to #callback" do
      expect(get("/auth/open_id/callback")).to route_to("sessions#create", :provider => 'open_id')
      expect(post("/auth/open_id/callback")).to route_to("sessions#create", :provider => 'open_id')
    end

    it "routes to #destroy" do
      expect(get("/signout")).to route_to("sessions#destroy")
    end

    it "routes to #failure" do
      expect(get("/auth/failure")).to route_to("sessions#failure")
    end

  end
end
