# -*- encoding: utf-8 -*-
class GistsController < ApplicationController

  before_filter :login_required, :only => [:mine, :mine_page, :fork]

  respond_to :html

  def index
    @gists = Gist.recent.page(1).per(10)
    @gist_list_title = "Latest Public Gists"
  end

  def show
    @gist = Gist.find_by_id(params[:id]) || Gist.find_my_gist_even_if_private(params[:id], current_user.try(:id))
    if @gist.nil?
      render_404
    else
      @gist_history = @gist.gist_histories.first
    end
  end

  def show_history
    @gist_history = GistHistory.find_by_id(params[:gist_history_id])
    if @gist_history.nil?
      return render_404
    end

    @gist = @gist_history.gist
    # gist id is invalid
    if @gist.nil? or @gist.id != params[:id].to_i
      return render_404
    end
    # private gist should be shown to only gist owner
    if @gist.user_id != current_user.try(:id) and !@gist.is_public
      return render_404
    end

    render action: "show"
  end

  def show_raw_file
    @gist = Gist.find_by_id(params[:id]) || Gist.find_my_gist_even_if_private(params[:id], current_user.try(:id))
    if @gist.nil?
      return render_404
    end
    @gist_file = GistFile.find_by_id(params[:gist_file_id])
    if @gist_file.nil? or @gist.id != @gist_file.gist_history.gist_id
      return render_404
    end
    respond_to { |format|
      format.text { render :text => @gist_file.body }
    }
  end

  def new
    @gist = Gist.new
    @gist_history = GistHistory.new
  end

  def edit
    @gist = Gist.find_by_id(params[:id]) || Gist.find_my_gist_even_if_private(params[:id], current_user.try(:id))
    if @gist.nil?
      redirect_to root_path
    else
      @gist_history = @gist.gist_histories.first
    end
  end

  def create
    transaction do
      @gist = Gist.new(
          :title => params[:gist][:title],
          :user_id => current_user.try(:id),
          :is_public => (current_user.nil? || params[:is_public] || false)
      )
      if @gist.save
        history = GistHistory.create(
            :gist_id => @gist.id,
            :user_id => current_user.try(:id)
        )
        gist_files = params[:gist_file_names].zip(params[:gist_file_bodies])
        if gist_files.select { |name, body| name.present? and body.present? }.empty?
          flash[:error] = 'Gist file is required.'
          return render action: "new"
        end
        gist_files.each do |name, body|
          GistFile.create(
              :gist_history_id => history.id,
              :name => name,
              :body => body
          )
        end
        redirect_to @gist, notice: 'Successfully created.'
      else
        render action: "new"
      end
    end
  end

  def update
    transaction do
      @gist = Gist.find_by_id(params[:id]) || Gist.find_my_gist_even_if_private(params[:id], current_user.try(:id))
      if @gist.nil?
        return render_404
      end
      if @gist.user_id.present? and @gist.user_id != current_user.try(:id)
        return redirect_to gists_path
      end

      @gist.title = params[:gist][:title]
      @gist.updated_at = Time.now
      if @gist.save
        history = GistHistory.create(
            :gist_id => @gist.id,
            :user_id => current_user.try(:id)
        )
        gist_files = params[:gist_file_names].zip(params[:gist_file_bodies])
        if gist_files.select { |name, body| name.present? and body.present? }.empty?
          flash[:error] = 'Gist file is required.'
          return render action: "edit"
        end
        gist_files.each do |name, body|
          GistFile.create(
              :gist_history_id => history.id,
              :name => name,
              :body => body
          )
        end
        redirect_to @gist, notice: 'Successfully updated.'
      else
        render action: "edit"
      end
    end
  end

  def fork
    transaction do
      gist_to_fork = Gist.find_by_id(params[:gist_id])
      if gist_to_fork.nil?
        return render_404
      end

      already_forked = Gist.find_already_forked(gist_to_fork.id, current_user.id)
      if already_forked.present?
        return redirect_to already_forked
      end
      created_gist = Gist.create(
          :title => gist_to_fork.title,
          :source_gist_id => gist_to_fork.id,
          :user_id => current_user.try(:id)
      )
      created_history = GistHistory.create(:gist_id => created_gist.id)

      gist_to_fork.latest_history.gist_files.each do |file|
        GistFile.create(
            :gist_history_id => created_history.id,
            :name => file.name,
            :body => file.body
        )
      end
      redirect_to created_gist, notice: 'Successfully forked.'
    end
  end

  def destroy
    gist = Gist.find_by_id(params[:id]) || Gist.find_my_gist_even_if_private(params[:id], current_user.try(:id))
    if gist.nil?
      return render_404
    end

    if gist.user_id.present? and gist.user_id != current_user.try(:id)
      return redirect_to root_path, notice: 'Not found.'
    else
      gist.destroy
      return redirect_to root_path, notice: 'Successfully deleted.'
    end
  end

  def add_gist_files_input
    respond_to { |format| format.js }
  end

  def mine
    @gists = Gist.find_my_recent_gists(current_user.id).page(1).per(10)
    @gist_list_title = "My Gists"
  end

  # ajax paginator
  def page
    respond_to { |format|
      format.js {
        @page = params[:page]
        @gists = Gist.recent.page(@page).per(10)
      }
    }
  end

  # ajax paginator
  def mine_page
    respond_to { |format|
      format.js {
        @page = params[:page]
        @gists = Gist.find_my_recent_gists(current_user.id).page(@page).per(10)
      }
    }
  end

  # ajax paginator
  def user_page
    respond_to { |format|
      format.js {
        @page = params[:page]
        @user = User.find_by_id(params[:user_id])
        if @user.nil?
          return render :text => "", :status => :not_found
        end
        @gists = Gist.where(:user_id => @user.id).page(@page).per(10)
      }
    }
  end

  # ajax paginator
  def user_fav_page
    respond_to { |format|
      format.js {
        @page = params[:page]
        @user = User.find_by_id(params[:user_id])
        if @user.nil?
          return render :text => "", :status => :not_found
        end
        @favorites = Favorite.where(:user_id => @user.id).page(@page).per(10)
      }
    }
  end

end
