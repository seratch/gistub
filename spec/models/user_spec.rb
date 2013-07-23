# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do

  it 'is available' do
    user = create(:user)
    user.should_not be_nil
  end

  it 'create with omniauth' do
    auth = {
        "provider" => 'open_id',
        "uid" => 'xxxxxx'
    }
    created = User.create_with_omniauth(auth)
    created.omniauth_provider.should eq('open_id')
    created.omniauth_uid.should eq('xxxxxx')
    created.nickname.should be_nil
  end

end
