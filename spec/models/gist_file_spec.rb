# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GistFile do

  it 'is available' do
    gist_file = create(:gist_file)
    expect(gist_file.gist_history).not_to be_nil
  end

end
