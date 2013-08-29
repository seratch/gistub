# -*- encoding : utf-8 -*-
Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  provider :open_id,
           :identifier => ENV['GISTUB_OPENID_IDENTIFIER'] || 'https://www.google.com/accounts/o8/id',
           :store => OpenID::Store::Filesystem.new("#{Rails.root}/tmp/openid")
end
