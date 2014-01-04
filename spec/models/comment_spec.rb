# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Comment do

  it 'is available' do
    comment = create(:comment)
    expect(comment.user).not_to be_nil
    expect(comment.gist).not_to be_nil
  end

end
