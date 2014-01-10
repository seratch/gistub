# -*- encoding : utf-8 -*-
require 'kramdown'
require 'digest/md5'
require 'cgi'

module ApplicationHelper

  def is_anonymous_gist_allowed
    anonymous_allowed || current_user.present?
  end

  def my_gists
    if current_user.present?
      Gist.limit(5).find_my_recent_gists(current_user.id)
    else
      nil
    end
  end

  def my_favorite_gists
    if current_user.present?
      favorites = Favorite.where(user_id: current_user.id).limit(5).order(:id).reverse_order
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
      Favorite.where(user_id: current_user.id).where(gist_id: gist.id).first
    else
      nil
    end
  end

  def favorite_users(gist)
    gist.favorites.map { |f| f.user }
  end

  def markdown(md_body)
    begin
      Kramdown::Document.new(md_body).to_html
    rescue Exception
      md_body
    end
  end

  def gravatar_image(user, options = {})
    return nil if user.nil? || user.email.nil?

    hash = Digest::MD5.hexdigest(user.email.downcase)
    opts = options.dup
    query = opts.select { |k, v| [:size, :d].include?(k) }
                .map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }
                .join('&')
    img_options = {
      :src => "//www.gravatar.com/avatar/#{hash}?#{query}",
      :alt => user.nickname
    }
    if size = options[:size]
      img_options[:width] = size
      img_options[:height] = size
    end

    tag 'img', img_options, false, false
  end
end
