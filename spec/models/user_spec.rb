# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do

  it 'is available' do
    user = create(:user)
    expect(user).not_to be_nil
  end

  it 'create with omniauth without email' do
    auth = {
        'provider' => 'open_id',
        'uid' => 'xxxxxx',
        'info' => {}
    }
    created = User.create_with_omniauth(auth)
    expect(created.omniauth_provider).to eq('open_id')
    expect(created.omniauth_uid).to eq('xxxxxx')
    expect(created.email).to be_nil
    expect(created.nickname).to be_nil
  end

  it 'create with omniauth with email' do
    auth = {
        'provider' => 'open_id',
        'uid' => 'xxxxxx',
        'info' => {
          'email' => 'test@test.org'
        }
    }
    created = User.create_with_omniauth(auth)
    expect(created.omniauth_provider).to eq('open_id')
    expect(created.omniauth_uid).to eq('xxxxxx')
    expect(created.email).to eq('test@test.org')
    expect(created.nickname).to be_nil
  end

end
