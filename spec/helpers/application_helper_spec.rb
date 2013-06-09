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
    it 'get something from #favorite_users' do
      favorite_users(gist).should_not be_nil
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

  describe 'markdown' do
    it 'works' do
      md_body = <<EOF
# foo

Something!

## Bar

- a
- b
- c
EOF
      result = markdown(md_body)
      expected = <<EOF
<h1 id="foo">foo</h1>

<p>Something!</p>

<h2 id="bar">Bar</h2>

<ul>
  <li>a</li>
  <li>b</li>
  <li>c</li>
</ul>
EOF
      result.should eq(expected)
    end
  end


end
