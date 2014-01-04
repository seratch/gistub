# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Gists" do

  describe "GET /gists" do
    it "works" do
      get gists_path
      expect(response.status).to be(200)
    end
  end

end
