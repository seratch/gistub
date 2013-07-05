# -*- encoding: utf-8 -*-

require 'spec_helper'

describe BasicPersistence do

  describe '#transaction' do
    it 'works' do
      Gist.transaction do 
         Gist.where(:id => 123).first
      end
    end
  end

end
