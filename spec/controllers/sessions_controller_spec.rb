# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SessionsController do
  let(:user) { create(:user) }

  def valid_session
    {:user_id => user.id}
  end

  describe "GET /sessions/start" do
    it "accepts requests" do
      get :start, {:return_to => '/foo'}, valid_session
      expect(response.status).to eq(302)
      expect(response.location).to eq("http://test.host/auth/open_id?return_to=/foo")
    end
  end

  describe "GET /sessions/failure" do
    it "accepts requests" do
      get :failure, {}, valid_session
      expect(response.status).to eq(200)
    end
  end

  describe "GET /auth/:provider/callback" do
    it "accepts requests without header" do
      get :create, {:provider => 'open_id'}
      expect(response.status).to eq(302)
      expect(response).to redirect_to root_path
    end
    it "creates new user" do
      expect {
        request.env['omniauth.auth'] = {
          'provider' => 'open_id',
          'uid' => 'yyy',
          'info' => { 'email' => 'test@test.org' }
        }
        get :create, {:provider => 'open_id'}
      }.to change { User.count }.from(0).to(1)
      u = User.first
      expect(u.omniauth_provider).to eq('open_id')
      expect(u.omniauth_uid).to eq('yyy')
      expect(u.email).to eq('test@test.org')
    end
    it "updates existing user" do
      expect {
        request.env['omniauth.auth'] = {
          'provider' => user.omniauth_provider,
          'uid' => user.omniauth_uid,
          'info' => { 'email' => 'test@test.org' }
        }
        get :create, {:provider => user.omniauth_provider}
      }.not_to change { User.count }.from(1)
      user.reload
      expect(user.email).to eq('test@test.org')
    end
  end

  describe "DELETE /sessions/destroy" do
    it "accepts requests" do
      post :destroy, {}, valid_session
      expect(response.status).to eq(302)
      expect(response).to redirect_to(root_path)
    end
  end

end
