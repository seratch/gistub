# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GistFile do

  it 'is available' do
    gist_file = create(:gist_file)
    gist_file.gist_history.should_not be_nil
  end

end
