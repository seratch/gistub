# -*- encoding : utf-8 -*-
class GistHistory < ActiveRecord::Base

  validates :gist_id, presence: true

  belongs_to :gist
  belongs_to :user

  has_many :gist_files

  default_scope { order(:id).reverse_order }

  def gist
    Gist.include_private.where(id: gist_id).first
  end

  def headline
    body = gist_files.first.try(:body)
    body.nil? ? '' : body.split("\n").take(3).join("\n")
  end

end
