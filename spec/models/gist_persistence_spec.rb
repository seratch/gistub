# -*- encoding : utf-8 -*-

require 'spec_helper'

describe GistPersistence do

  describe '#save_history!' do
    it 'works' do
      flash = stub('flash')
      gist = create(:gist)      
      user = create(:user)
      history = GistPersistence.new(flash).save_history!(gist.id, user.id)
      expect(history).not_to be_nil
    end
  end

  describe '#save_files!' do
    it 'works' do
      flash = stub('flash')
      history = create(:gist_history)
      gist_files = [['name', 'body']]
      result = GistPersistence.new(flash).save_files!(history, gist_files)
      expect(result).not_to be_nil
    end
  end

  describe '#save!' do
    it 'works' do
      flash = stub('flash')
      gist_creation = GistPersistence.new(flash)
      gist = build(:gist)
      gist_files = [['name', 'body']]
      current_user = nil
      result = gist_creation.save!(gist, gist_files, current_user)
      expect(result).not_to be_nil
    end
  end


end
