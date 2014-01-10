# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ApplicationHelper do

  let(:user) { create(:user) }
  let(:gist) { create(:gist, :user => user) }

  describe "anonymous gist" do
    # from ApplicationController
    def current_user
      nil
    end
    def anonymous_allowed
      false
    end

    it 'is_anonymous_gist_allowed' do
      expect(is_anonymous_gist_allowed).to be_false
    end

  end

  describe "-- if current_user is nil --" do
    # from ApplicationController
    def current_user
      nil
    end
    def anonymous_allowed
      true
    end

    it 'is_anonymous_gist_allowed' do
      expect(is_anonymous_gist_allowed).to be_true
    end

    it 'get nil from #my_gists' do
      expect(my_gists).to be_nil
    end
    it 'get nil from #my_favorite_gists' do
      expect(my_gists).to be_nil
    end
    it 'get nil from #find_my_favorite' do
      expect(find_my_favorite(gist)).to be_nil
    end
    it 'get false from #is_already_favorited' do
      expect(is_already_favorited(gist)).to eq(false)
    end

    it 'get something from #recent_gists' do
      expect(recent_gists).not_to be_nil
    end
    it 'get something from #favorite_users' do
      expect(favorite_users(gist)).not_to be_nil
    end
  end

  describe "-- if current_user is NOT null --" do
    def current_user
      user
    end

    it 'get something from #my_gists' do
      expect(my_gists).not_to be_nil
    end
    it 'get something from #my_favorite_gists' do
      expect(my_favorite_gists).not_to be_nil
    end
    it 'get nil from #find_my_favorite' do
      fav = Favorite.create(:gist_id => gist.id, :user_id => user.id)
      expect(find_my_favorite(gist)).to eq(fav)
    end
    it 'get false from #is_already_favorited' do
      Favorite.create(:gist_id => gist.id, :user_id => user.id)
      expect(is_already_favorited(gist)).to eq(true)
    end
  end

  describe 'markdown' do
    it "doesn't interpret the body when it fails" do
      allow_any_instance_of(Kramdown::Document).to receive(:to_html) { raise Kramdown::Error }
      md_body = "Simulating error thrown by Kramdown"

      expect(markdown(md_body)).to eq(md_body)
    end

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
      expect(result).to eq(expected)
    end
  end

  describe 'gravatar_image' do
    it 'returns nil for user without email' do
      u = create(:user, :email => nil)
      result = gravatar_image(u)
      expect(result).to be_nil
    end

    it 'works' do
      u = create(:user, :nickname => 'Foo', :email => 'foo@bar.com')
      options = {
        :size => 25,
        :d => 'http://test.com/default.jpg'
      }
      result = gravatar_image(u, options)
      expected = '<img alt="Foo" height="25" src="//www.gravatar.com/avatar/f3ada405ce890b6f8204094deb12d8a8?size=25&d=http%3A%2F%2Ftest.com%2Fdefault.jpg" width="25" />'
      expect(result).to eq(expected)
    end
  end
end
