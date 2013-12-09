# -*- encoding : utf-8 -*-
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
      expect(response).to render_template("root/index")
      expect(response.status).to eq(200)
      expect(response.body).to match(%r{<h4>My Gists</h4>})
      expect(response.body).to match(%r{<h4>Favorite Gists</h4>})
    end

    it "contains content" do
      get :index, {}, {}
      expect(response).to render_template("root/index")
      expect(response.status).to eq(200)
      expect(response.body).not_to match(%r{<h4>My Gists</h4>})
      expect(response.body).not_to match(%r{<h4>Favorite Gists</h4>})
    end
  end

end
