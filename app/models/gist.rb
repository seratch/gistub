# -*- encoding : utf-8 -*-
class Gist < ActiveRecord::Base

  attr_accessible :title,
                  :is_public,
                  :user_id,
                  :source_gist_id

  validates :title, presence: true

  belongs_to :user
  belongs_to :source_gist, class_name: Gist

  has_many :gist_histories
  has_many :comments
  has_many :favorites

  default_scope {
    order(:id)
      .where(is_public: true)
      .includes(:gist_histories)
      .includes(:comments)
      .includes(:favorites)
  }

  scope :recent, lambda { order(:created_at).reverse_order }

  def self.search(query, current_user_id, page)
    keywords = query.split("\s")
    like_parts = keywords.map { |keyword| "%#{keyword}%" }

    gist_ids_from_gists = find_gist_ids_from_gists(like_parts, current_user_id)
    gist_ids_from_files = find_gist_ids_from_gist_files(like_parts, current_user_id)
    ids = (gist_ids_from_gists + gist_ids_from_files).uniq 

    find_visible_gists_in(ids, current_user_id, page)
  end

  def latest_history
    gist_histories.first
  end

  def forks
    Gist.recent.find_all_by_source_gist_id(id)
  end

  def self.include_private
    unscoped.includes(:gist_histories)
  end

  def self.find_already_forked(source_gist_id, user_id)
    Gist.where(source_gist_id: source_gist_id, user_id: user_id).first
  end

  def self.find_my_recent_gists(user_id)
    Gist.include_private.where(user_id: user_id).recent
  end

  def self.find_my_gist_even_if_private(id, user_id)
    if user_id.nil?
      where(id: id).first
    else
      my_gist = reduce(where(id: id, user_id: user_id))
      public_gist = reduce(where(id: id, is_public: true))
      include_private.where(my_gist.or(public_gist)).first
    end
  end

  def self.find_commentable_gist(id, user_id)
    public_gist = where(id: id).first
    if public_gist.present?
      public_gist
    else
      find_my_gist_even_if_private(id, user_id)
    end
  end

  private

  def self.reduce(where)
    where.where_values.reduce(:and)
  end

  def self.find_gist_ids_from_gists(like_parts, current_user_id)
    g = Gist.arel_table

    query = g[:is_public].eq(true).or(g[:user_id].eq(current_user_id))

    query = query.and(g[:title].matches(like_parts.first))
    query = like_parts.drop(1).reduce(query) { |q, like_part| 
      q.and(g[:title].matches(like_part)) 
    }

    Gist.include_private.where(query).pluck(:id)
  end

  def self.find_gist_ids_from_gist_files(like_parts, current_user_id)
    gf = GistFile.arel_table

    query = gf[:name].matches(like_parts.first).or(gf[:body].matches(like_parts.first))
    query = like_parts.drop(1).reduce(query) { |q, like_part|
      q.and(gf[:name].matches(like_part).or(gf[:body].matches(like_part)))
    }

    GistFile.where(query).joins(:gist_history).pluck('gist_histories.gist_id').uniq
  end

  def self.find_visible_gists_in(ids, current_user_id, page)
    g = Gist.arel_table
    Gist.include_private
      .where(g[:is_public].eq(true).or(g[:user_id].eq(current_user_id)))
      .where(id: ids)
      .order(:created_at)
      .reverse_order
      .page(page).per(10)
  end

end
