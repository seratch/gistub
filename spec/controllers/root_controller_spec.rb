require 'spec_helper'

describe RootController do

  # for response.body
  render_views

  let(:user) { create(:user) }

  def valid_session
    {:user_id => user.id}
  end

  describe "GET index" do
    it "contains content for logged in user" do
      get :index, {}, valid_session
      response.should render_template("root/index")
      response.status.should eq(200)
      response.body.should match(%r{<h4>My Gists</h4>})
      response.body.should match(%r{<h4>Favorite Gists</h4>})
    end

    it "contains content" do
      get :index, {}, {}
      response.should render_template("root/index")
      response.status.should eq(200)
      response.body.should_not match(%r{<h4>My Gists</h4>})
      response.body.should_not match(%r{<h4>Favorite Gists</h4>})
    end
  end

end
