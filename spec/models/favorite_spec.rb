require 'spec_helper'

describe Favorite do

  it 'is available' do
    favorite = create(:favorite)
    favorite.user.should_not be_nil
    favorite.gist.should_not be_nil
  end

end
