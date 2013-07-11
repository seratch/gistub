# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  validates :omniauth_provider, presence: true
  validates :omniauth_uid,      presence: true

  has_many :gists,    -> { order(:updated_at => :desc) }
  has_many :comments, -> { order(:updated_at => :desc) }

  def self.create_with_omniauth(auth)
    create! do |user|
      user.omniauth_provider = auth['provider']
      user.omniauth_uid = auth['uid']
      user.nickname = nil
    end
  end


end
