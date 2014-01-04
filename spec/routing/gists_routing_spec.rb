# -*- encoding : utf-8 -*-
require "spec_helper"

describe GistsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/gists")).to route_to("gists#index")
    end

    it "routes to #new" do
      expect(get("/gists/new")).to route_to("gists#new")
    end

    it "routes to #show" do
      expect(get("/gists/1")).to route_to("gists#show", :id => "1")
    end

    it "routes to #show_history" do
      expect(get("/gists/1/history/2")).to route_to("gists#show_history", :id => "1", :gist_history_id => "2")
    end

    it "routes to #show_raw_file" do
      expect(get("/gists/1/raw_file/2")).to route_to("gists#show_raw_file", :id => "1", :gist_file_id => "2")
    end

    it "routes to #edit" do
      expect(get("/gists/1/edit")).to route_to("gists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/gists")).to route_to("gists#create")
    end

    it "routes to #update" do
      expect(put("/gists/1")).to route_to("gists#update", :id => "1")
    end

    it "routes to #fork" do
      expect(post("/gists/1/fork")).to route_to("gists#fork", :gist_id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/gists/1")).to route_to("gists#destroy", :id => "1")
    end

    it "routes to #page" do
      expect(get("/gists/page")).to route_to("gists#page")
    end

    it "routes to #user_page" do
      expect(get("/gists/user_page")).to route_to("gists#user_page")
    end

    it "routes to #mine" do
      expect(get("/gists/mine")).to route_to("gists#mine")
    end

    it "routes to #mine_page" do
      expect(get("/gists/mine_page")).to route_to("gists#mine_page")
    end

    it "routes to #user_fav_page" do
      expect(get("/gists/user_fav_page")).to route_to("gists#user_fav_page")
    end

    it "routes to #add_gist_files_input" do
      expect(get("/gists/add_gist_files_input")).to route_to("gists#add_gist_files_input")
    end

  end
end
