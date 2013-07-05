# -*- encoding : utf-8 -*-

require 'spec_helper'

describe GistForkCreation do

  describe '#save!' do
    it 'works' do
      gist_fork_creation = GistForkCreation.new
      gist_to_fork = create(:gist_history).gist
      current_user = nil
      result = gist_fork_creation.save!(gist_to_fork, current_user)
      expect(result).not_to be_nil
    end
  end

end
