# -*- encoding : utf-8 -*-
class Comment < ActiveRecord::Base

  attr_accessible :body,
                  :gist_id,
                  :user_id

  validates :body,    presence: true
  validates :gist_id, presence: true
  validates :user_id, presence: true

  belongs_to :gist
  belongs_to :user

end
