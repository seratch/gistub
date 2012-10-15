require 'spec_helper'

describe SessionsController do
  let(:user) { create(:user) }

  def valid_session
    {:user_id => user.id}
  end

  describe "GET /sessions/start" do
    it "accepts requests" do
      get :start, {:return_to => '/foo'}, valid_session
      response.status.should eq(302)
      response.location.should eq("http://test.host/auth/open_id?return_to=/foo")
    end
  end

  describe "GET /sessions/failure" do
    it "accepts requests" do
      get :failure, {}, valid_session
      response.status.should eq(200)
    end
  end

  describe "GET /auth/:provider/callback" do
    it "accepts requests without header" do
      get :create, {:provider => 'open_id'}, valid_session
      response.status.should eq(302)
      response.should redirect_to root_path
    end
    it "accepts requests" do
      request.env['omniauth.auth'] = {
          "provider" => 'open_id',
          "uid" => "xxx"
      }
      get :create, {:provider => 'open_id', :return_to => '/foo'}, valid_session
      response.status.should eq(302)
      response.should redirect_to 'http://test.host/foo'
    end
  end

  describe "DELETE /sessions/destroy" do
    it "accepts requests" do
      post :destroy, {}, valid_session
      response.status.should eq(302)
      response.should redirect_to(root_path)
    end
  end

end
