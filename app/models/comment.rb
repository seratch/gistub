# -*- encoding : utf-8 -*-
class Comment < ActiveRecord::Base

  validates :body,    presence: true
  validates :gist_id, presence: true
  validates :user_id, presence: true

  belongs_to :gist
  belongs_to :user

end
