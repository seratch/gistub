# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Users" do

  describe "GET /user/:id" do
    it "works" do
      user = create(:user, :nickname => 'XXXXX')
      get user_path(user)
      response.status.should be(200)
      response.body.include?("XXXXX").should be_true
    end
  end

end
