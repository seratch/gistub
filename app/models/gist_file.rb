class GistFile < ActiveRecord::Base

  validates :name, :presence => true
  validates :body, :presence => true
  validates :gist_history_id, :presence => true

  belongs_to :gist_history

end
