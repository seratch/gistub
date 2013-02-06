class Gist < ActiveRecord::Base

  attr_accessible :title,
                  :is_public,
                  :user_id,
                  :source_gist_id

  validates :title, :presence => true

  belongs_to :user
  belongs_to :source_gist, :class_name => Gist
  has_many :gist_histories
  has_many :comments
  has_many :favorites

  default_scope order(:id).where(:is_public => true).includes(:gist_histories).includes(:comments).includes(:favorites)

  scope :recent, lambda { order(:created_at).reverse_order }

  def self.search(query, current_user_id, page)
    keywords = query.split("\s")
    like_parts = keywords.map { |keyword| "%#{keyword}%" }
    first_like_part = like_parts.first

    # find from gists
    gists = Gist.arel_table
    query_for_gists = gists[:title].matches(first_like_part)
      .and(gists[:is_public].eq(true).or(gists[:user_id].eq(current_user_id)))
    query_for_gists = like_parts.drop(1).inject(query_for_gists) { |q, like_part|
      q.and(gists[:title].matches(like_part))
    }
    gist_id_list = Gist.include_private.where(query_for_gists).pluck(:id)

    # find from gist_files(contains others' private gists)
    gist_files = GistFile.arel_table
    query_for_gist_files = gist_files[:name].matches(first_like_part)
      .or(gist_files[:body].matches(first_like_part))
    query_for_gist_files = like_parts.drop(1).inject(query_for_gist_files) { |q, like_part|
      q.and(gist_files[:name].matches(like_part).or(gist_files[:body].matches(like_part)))
    }
    gist_id_list_for_files = GistFile.where(query_for_gist_files)
      .joins(:gist_history)
      .order("gist_histories.created_at")
      .reverse_order.pluck("gist_histories.gist_id")
      .uniq

    Gist.include_private
      .where(gists[:is_public].eq(true).or(gists[:user_id].eq(current_user_id)))
      .where(:id => (gist_id_list + gist_id_list_for_files).uniq)
      .order(:created_at)
      .reverse_order
      .page(page).per(10)
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
    Gist.where(:source_gist_id => source_gist_id, :user_id => user_id).first
  end

  def self.find_my_recent_gists(user_id)
    Gist.include_private.where(:user_id => user_id).recent
  end

  def self.find_my_gist_even_if_private(id, user_id)
    if user_id.nil?
      where(:id => id).first
    else
      my_gist = reduce(where(:id => id, :user_id => user_id))
      public_gist = reduce(where(:id => id, :is_public => true))
      include_private.where(my_gist.or(public_gist)).first
    end
  end

  def self.find_commentable_gist(id, user_id)
    public_gist = where(:id => id).first
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

end
