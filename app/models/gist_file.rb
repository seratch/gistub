# -*- encoding : utf-8 -*-
class GistFile < ActiveRecord::Base

  attr_accessible :name,
                  :body,
                  :gist_history_id

  validates :name,            presence: true
  validates :body,            presence: true
  validates :gist_history_id, presence: true

  belongs_to :gist_history

end
