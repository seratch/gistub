module ApplicationHelper

  def my_gists
    if current_user.present?
      Gist.limit(5).find_my_recent_gists(current_user.id)
    else
      nil
    end
  end

  def my_favorite_gists
    if current_user.present?
      favorites = Favorite.where(:user_id => current_user.id).limit(5).order(:id).reverse_order
      favorites.map { |fav| fav.gist }.select(&:present?)
    else
      nil
    end
  end

  def recent_gists
    Gist.recent.limit(10).find_all
  end

  def is_already_favorited(gist)
    find_my_favorite(gist).present?
  end

  def find_my_favorite(gist)
    if current_user.present?
      Favorite.where(:user_id => current_user.id).where(:gist_id => gist.id).first
    else
      nil
    end
  end

  def favorite_count(gist)
    gist.favorites.try(:size)
  end

end
