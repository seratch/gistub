# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessible :nickname,
                  :omniauth_provider,
                  :omniauth_uid

  validates :omniauth_provider, presence: true
  validates :omniauth_uid,      presence: true

  has_many :gists
  has_many :comments

  def self.create_with_omniauth(auth)
    create! do |user|
      user.omniauth_provider = auth['provider']
      user.omniauth_uid = auth['uid']
      user.nickname = nil
    end
  end


end
