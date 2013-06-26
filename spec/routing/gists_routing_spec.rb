require "spec_helper"

describe GistsController do
  describe "routing" do

    it "routes to #index" do
      get("/gists").should route_to("gists#index")
    end

    it "routes to #new" do
      get("/gists/new").should route_to("gists#new")
    end

    it "routes to #show" do
      get("/gists/1").should route_to("gists#show", :id => "1")
    end

    it "routes to #show_history" do
      get("/gists/1/history/2").should route_to("gists#show_history", :id => "1", :gist_history_id => "2")
    end

    it "routes to #show_raw_file" do
      get("/gists/1/raw_file/2").should route_to(:controller => "gists", :action => "show_raw_file", :id => "1", :gist_file_id => "2")
    end

    it "routes to #edit" do
      get("/gists/1/edit").should route_to("gists#edit", :id => "1")
    end

    it "routes to #create" do
      post("/gists").should route_to("gists#create")
    end

    it "routes to #update" do
      put("/gists/1").should route_to("gists#update", :id => "1")
    end

    it "routes to #fork" do
      post("/gists/1/fork").should route_to("gists#fork", :gist_id => "1")
    end

    it "routes to #destroy" do
      delete("/gists/1").should route_to("gists#destroy", :id => "1")
    end

    it "routes to #page" do
      get("/gists/page").should route_to("gists#page")
    end

    it "routes to #user_page" do
      get("/gists/user_page").should route_to("gists#user_page")
    end

    it "routes to #mine" do
      get("/gists/mine").should route_to("gists#mine")
    end

    it "routes to #mine_page" do
      get("/gists/mine_page").should route_to("gists#mine_page")
    end

    it "routes to #user_fav_page" do
      get("/gists/user_fav_page").should route_to("gists#user_fav_page")
    end

    it "routes to #add_gist_files_input" do
      get("/gists/add_gist_files_input").should route_to("gists#add_gist_files_input")
    end

  end
end
