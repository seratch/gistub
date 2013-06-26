# -*- encoding: utf-8 -*-
class CommentsController < ApplicationController

  before_action :login_required

  respond_to :html

  def create
    @gist = Gist.find_commentable_gist(params[:gist_id], current_user.try(:id))
    @gist_history = @gist.latest_history
    comment = Comment.new()
    comment.gist_id = @gist.id
    comment.user_id = current_user.try(:id)
    comment.body = params[:body]
    if comment.save
      redirect_to gist_path(@gist.id), notice: 'Comment is successfully added.'
    else
      render action: "../gists/show"
    end
  end

  def destroy
    comment = Comment.where(:id => params[:id], :user_id => current_user.try(:id)).first
    if comment.present?
      comment.destroy
      redirect_to gist_path(params[:gist_id]), notice: 'Comment is successfully removed.'
    else
      redirect_to gist_path(params[:gist_id]), notice: 'Not found.'
    end
  end

end
