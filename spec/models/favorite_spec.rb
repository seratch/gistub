# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Favorite do

  it 'is available' do
    favorite = create(:favorite)
    expect(favorite.user).not_to be_nil
    expect(favorite.gist).not_to be_nil
  end

end
