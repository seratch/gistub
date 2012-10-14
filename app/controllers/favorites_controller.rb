# -*- encoding: utf-8 -*-
class FavoritesController < ApplicationController

  before_filter :login_required

  respond_to :html

  def create
    @gist = Gist.find_commentable_gist(params[:gist_id], current_user.try(:id))
    fav = Favorite.new()
    fav.gist_id = @gist.id
    fav.user_id = current_user.id
    if fav.save
      redirect_to gist_path(@gist.id), notice: 'You liked this gist.'
    else
      render action: "../gists/show"
    end
  end

  def destroy
    own_fav = Favorite.find_by_id_and_user_id(params[:id], current_user.try(:id))
    if own_fav.present?
      own_fav.destroy
      redirect_to gist_path(params[:gist_id]), notice: 'Your love is cancelled.'
    else
      redirect_to gist_path(params[:gist_id]), notice: 'Not found.'
    end
  end

end
