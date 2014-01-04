# -*- encoding : utf-8 -*-
require 'spec_helper'

describe RootController do

  let(:user) { create(:user) }
  let(:user_without_nickname) { create(:user, :nickname => nil)  }

  def valid_session
    {:user_id => user.id}
  end

  def no_nickname_session
    {:user_id => user_without_nickname.id}
  end

  describe 'APIs from ApplicationController' do
    it 'provides #current_user' do
      user.destroy
      get :index, {}, valid_session
    end

    it 'provides #nickname_required' do
      get :index, {}, no_nickname_session
      expect(response).to redirect_to edit_user_path(user_without_nickname)
    end
  end

end

describe CommentsController do

  describe 'APIs from ApplicationController' do
    it 'provides #login_required' do
      post :create, {:gist_id => 1}, {}
      expect(response.status).to eq(302)
      expect(response).to redirect_to('http://test.host/signin?return_to=http%3A%2F%2Ftest.host%2Fgists%2F1%2Fcomments')
    end
  end

end
