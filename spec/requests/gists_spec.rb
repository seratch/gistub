# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Gists" do

  describe "GET /gists" do
    it "works" do
      get gists_path
      response.status.should be(200)
    end
  end

end
