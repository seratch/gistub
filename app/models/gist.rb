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

  default_scope order(:id).where(:is_public => true)

  scope :recent, lambda { order(:created_at).reverse_order }

  def latest_history
    gist_histories.first
  end

  def forks
    Gist.recent.find_all_by_source_gist_id(id)
  end

  def self.include_private
    unscoped
  end

  def self.find_already_forked(source_gist_id, user_id)
    Gist.find_by_source_gist_id_and_user_id(source_gist_id, user_id)
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
    public_gist = find_by_id(id)
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
