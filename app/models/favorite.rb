# -*- encoding : utf-8 -*-
class Favorite < ActiveRecord::Base

  validates :gist_id, presence: true
  validates :user_id, presence: true

  belongs_to :gist
  belongs_to :user

  scope :recent, lambda { order(:created_at).reverse_order }

end
