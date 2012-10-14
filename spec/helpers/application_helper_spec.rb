require 'spec_helper'

describe ApplicationHelper do

  let(:user) { create(:user) }
  let(:gist) { create(:gist, :user => user) }


  describe "-- if current_user is nil --" do
    # from ApplicationController
    def current_user
      nil
    end

    it 'get nil from #my_gists' do
      my_gists.should be_nil
    end
    it 'get nil from #my_favorite_gists' do
      my_gists.should be_nil
    end
    it 'get nil from #find_my_favorite' do
      find_my_favorite(gist).should be_nil
    end
    it 'get false from #is_already_favorited' do
      is_already_favorited(gist).should eq(false)
    end

    it 'get something from #recent_gists' do
      recent_gists.should_not be_nil
    end
    it 'get something from #favorite_count' do
      favorite_count(gist).should_not be_nil
    end
  end

  describe "-- if current_user is NOT null --" do
    def current_user
      user
    end

    it 'get something from #my_gists' do
      my_gists.should_not be_nil
    end
    it 'get something from #my_favorite_gists' do
      my_favorite_gists.should_not be_nil
    end
    it 'get nil from #find_my_favorite' do
      fav = Favorite.create(:gist_id => gist.id, :user_id => user.id)
      find_my_favorite(gist).should eq(fav)
    end
    it 'get false from #is_already_favorited' do
      Favorite.create(:gist_id => gist.id, :user_id => user.id)
      is_already_favorited(gist).should eq(true)
    end
  end

end
