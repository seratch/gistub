# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FavoritesController do
  let(:gist) { create(:gist) }
  let(:user) { create(:user) }

  def valid_session
    {:user_id => user.id}
  end

  describe "POST create" do
    it "creates a new Favorite and redirects to the gist" do
      expect {
        post :create, {:gist_id => gist.id}, valid_session
      }.to change(Favorite, :count).by(1)
      expect(response).to redirect_to(gist)
    end

    it "shows ../gists/show when failing to create a new favorite" do
      allow_any_instance_of(Favorite).to receive(:save).and_return(false)
      post :create, {:gist_id => gist.id}, valid_session
      expect(response).to render_template("../gists/show")
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested favorite and redirects to the gist page" do
      fav = create(:favorite, :gist => gist, :user => user)
      expect {
        delete :destroy, {:gist_id => gist.id, :id => fav.id}, valid_session
      }.to change(Favorite, :count).by(-1)
      expect(response).to redirect_to(gist)
    end

    it "redirects to gist when the favorite is not found" do
      expect {
        delete :destroy, {:gist_id => gist.id, :id => -1}, valid_session
      }.to change(Favorite, :count).by(0)
      expect(response).to redirect_to(gist)
    end
  end

end
