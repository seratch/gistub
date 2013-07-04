# -*- encoding: utf-8 -*-

require 'spec_helper'

describe GistCreation do

  describe '#new' do
    it 'works' do
      flash = stub('flash')
      result = GistCreation.new(flash)
      expect(result).not_to be_nil
    end
  end

  describe '#save!' do
    it 'works' do
      flash = stub('flash')
      gist_creation = GistCreation.new(flash)
      gist = build(:gist)
      gist_files = [['name', 'body']]
      current_user = nil
      result = gist_creation.save!(gist, gist_files, current_user)
      expect(result).not_to be_nil
    end
  end

end
