# -*- encoding : utf-8 -*-
class CommentsController < ApplicationController

  before_filter :login_required

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
    destroy_and_redirect_to_gist(comment, 'Comment is successfully removed.', 'Not found.')
  end

end
