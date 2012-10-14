require "spec_helper"

describe SessionsController do
  describe "routing" do

    it "routes to #start" do
      get("/signin").should route_to("sessions#start")
    end

    it "routes to #callback" do
      get("/auth/open_id/callback").should route_to("sessions#create", :provider => 'open_id')
    end

    it "routes to #destroy" do
      get("/signout").should route_to("sessions#destroy")
    end

    it "routes to #failure" do
      get("/auth/failure").should route_to("sessions#failure")
    end

  end
end
