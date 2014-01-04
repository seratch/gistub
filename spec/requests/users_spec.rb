# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Users" do

  describe "GET /user/:id" do
    it "works" do
      user = create(:user, :nickname => 'XXXXX')
      get user_path(user)
      expect(response.status).to be(200)
      expect(response.body.include?("XXXXX")).to be_true
    end
  end

end
