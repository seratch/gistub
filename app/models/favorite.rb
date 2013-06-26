class Favorite < ActiveRecord::Base

  validates :gist_id, :presence => true
  validates :user_id, :presence => true

  belongs_to :gist
  belongs_to :user

end
