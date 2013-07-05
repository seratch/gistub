# -*- encoding: utf-8 -*-

require 'spec_helper'

describe GistPersistence do

  describe '#save_history!' do
    it 'works' do
      flash = stub('flash')
      gist = create(:gist)      
      user = create(:user)
      history = GistCreation.new(flash).save_history!(gist.id, user.id)
      expect(history).not_to be_nil
    end
  end

  describe '#save_files!' do
    it 'works' do
      flash = stub('flash')
      history = create(:gist_history)
      gist_files = [['name', 'body']]
      result = GistCreation.new(flash).save_files!(history, gist_files)
      expect(result).not_to be_nil
    end
  end

end
