# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Gist do

  it 'is available' do
    gist = create(:gist)
    expect(gist.user).not_to be_nil
  end

  it 'returns latest_history' do
    history1 = create(:gist_history)
    history2 = create(:gist_history, :gist => history1.gist)

    gist = history1.gist
    expect(gist.latest_history).to eq(history2)
  end

  it 'returns forks' do
    gist = create(:gist)
    fork1 = create(:gist, :source_gist => gist)
    fork2 = create(:gist, :source_gist => gist)

    expect(gist.forks.size).to eq(2)
    expect(gist.forks.map { |f| f.id }).to eq([fork2.id, fork1.id])
  end

  it 'finds already forked gist' do
    user = create(:user)
    gist = create(:gist)

    expect(Gist.find_already_forked(gist.id, user.id)).to be_nil

    forked = create(:gist, :source_gist => gist, :user => user)
    expect(Gist.find_already_forked(gist.id, user.id).id).to eq(forked.id)
  end

  it 'returns my gists' do
    user = create(:user)
    create(:gist, :user => user)
    create(:gist, :user => user)
    create(:gist, :user => user)

    mine = Gist.find_my_recent_gists(user.id)
    expect(mine.size).to eq(3)
  end

  it 'finds my gist even if private' do
    user = create(:user)

    public_gist = create(:gist, :is_public => true, :user => user)
    found = Gist.find_my_gist_even_if_private(public_gist.id, user.id)
    expect(found).not_to be_nil

    private_gist = create(:gist, :is_public => false, :user => user)
    found = Gist.find_my_gist_even_if_private(private_gist.id, user.id)
    expect(found).not_to be_nil

    other_user = create(:user)
    not_found = Gist.find_my_gist_even_if_private(private_gist.id, other_user.id)
    expect(not_found).to be_nil
  end

  it 'finds commentable gist' do
    user = create(:user)

    public_gist = create(:gist)
    found = Gist.find_commentable_gist(public_gist.id, user.id)
    expect(found).not_to be_nil

    my_private_gist = create(:gist, :is_public => false, :user => user)
    found = Gist.find_commentable_gist(my_private_gist.id, user.id)
    expect(found).not_to be_nil

    other_user = create(:user)
    private_gist = create(:gist, :is_public => false, :user => other_user)
    not_found = Gist.find_commentable_gist(private_gist.id, user.id)
    expect(not_found).to be_nil
  end

  it 'search something' do
    user = create(:user)
    public_gist = create(:gist)

    query = public_gist.title
    current_user_id = user.id
    page = 1
    found_gists = Gist.search(query, current_user_id, page)
    expect(found_gists.size).to be > 0
  end

  it 'includes private gists' do
    result = Gist.include_private()
    expect(result).not_to be_nil
  end

end
