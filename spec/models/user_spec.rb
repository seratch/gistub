# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do

  it 'is available' do
    user = create(:user)
    expect(user).not_to be_nil
  end

  it 'create with omniauth' do
    auth = {
        "provider" => 'open_id',
        "uid" => 'xxxxxx'
    }
    created = User.create_with_omniauth(auth)
    expect(created.omniauth_provider).to eq('open_id')
    expect(created.omniauth_uid).to eq('xxxxxx')
    expect(created.nickname).to be_nil
  end

end
