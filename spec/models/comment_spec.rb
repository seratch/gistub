# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Comment do

  it 'is available' do
    comment = create(:comment)
    comment.user.should_not be_nil
    comment.gist.should_not be_nil
  end

end
