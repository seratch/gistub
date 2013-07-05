# -*- encoding : utf-8 -*-
class GistsController < ApplicationController

  before_filter :login_required, only: [:mine, :mine_page, :fork]

  before_filter :deny_anonymous_if_disallowed, only: [:new, :create, :edit, :update]

  def deny_anonymous_if_disallowed
    anonymous_allowed || login_required
  end

  respond_to :html

  def index
    @gists = Gist.recent.page(1).per(10)
    @gist_list_title = 'Public Gists'
  end

  def search
    if params[:search_query].present?
      @search_query = params[:search_query]
      @gists = Gist.search(@search_query, current_user.try(:id), 1)
      @gist_list_title = 'Search Result'
    else
      @gists = Gist.recent.page(1).per(10)
    end

    render action: 'index'
  end

  def show
    @gist = find_visible_gist_by_id(params[:id], current_user)
    if @gist 
      @gist_history = @gist.gist_histories.first
    else
      render_404
    end
  end

  def show_history
    @gist_history = GistHistory.where(id: params[:gist_history_id]).first
    return render_404 if @gist_history.nil? || @gist_history.gist.nil?

    @gist = @gist_history.gist

    if is_path_param_gist_id_valid? || is_not_visible_gist?
      render_404
    else
      render action: 'show'
    end
  end

  def show_raw_file
    @gist = find_visible_gist_by_id(params[:id], current_user)
    return render_404 unless @gist

    @gist_file = GistFile.where(id: params[:gist_file_id]).first
    return render_404 if @gist_file.nil? || @gist.id != @gist_file.gist_history.gist_id

    respond_to { |format|
      format.text { render text: @gist_file.body }
    }
  end

  def new
    @gist = Gist.new
    @gist_history = GistHistory.new
  end

  def edit
    @gist = find_visible_gist_by_id(params[:id], current_user)
    if @gist
      @gist_history = @gist.gist_histories.first
    else
      redirect_to root_path
    end
  end

  def create
    @gist = Gist.new(
      title: params[:gist][:title],
      user_id: current_user.try(:id),
      is_public: (current_user.nil? || params[:is_public] || false)
    )
    save_gist_and_redirect(GistPersistence.new(flash), 'new')
  end

  def update
    @gist = find_visible_gist_by_id(params[:id], current_user)
    return render_404 unless @gist

    if @gist.user_id.present? && @gist.user_id != current_user.try(:id)
      return redirect_to gists_path
    end

    @gist.title = params[:gist][:title]
    @gist.updated_at = Time.now

    save_gist_and_redirect(GistPersistence.new(flash), 'edit')
  end

  def fork
    gist_to_fork = Gist.where(id: params[:gist_id]).first
    return render_404 unless gist_to_fork

    already_forked = Gist.find_already_forked(gist_to_fork.id, current_user.id)
    return redirect_to already_forked if already_forked.present?

    begin
      created_gist = GistForkCreation.new.save!(gist_to_fork, current_user)
      redirect_to created_gist, notice: 'Successfully forked.'
    rescue Exception => e
      debug_log_back_trace(e)
      redirect_to gist_to_fork, notice: 'Failed to fork.'
    end
  end

  def destroy
    gist = find_visible_gist_by_id(params[:id], current_user)
    return render_404 unless gist

    if gist.user_id.present? && gist.user_id != current_user.try(:id)
      redirect_to root_path, notice: 'Not found.'
    else
      gist.destroy
      redirect_to root_path, notice: 'Successfully deleted.'
    end
  end

  def add_gist_files_input
    respond_as_js {}
  end

  def mine
    @gists = Gist.find_my_recent_gists(current_user.id).page(1).per(10)
    @gist_list_title = 'My Gists'
  end

  # ajax paginator
  def page
    paginator_respond_as_js {
      if params[:search_query].present?
        @search_query = params[:search_query]
        @gists = Gist.search(@search_query, current_user.try(:id), @page)
      else
        @gists = Gist.recent.page(@page).per(10)
      end
    }
  end

  # ajax paginator
  def mine_page
    paginator_respond_as_js {
      @gists = Gist.find_my_recent_gists(current_user.id).page(@page).per(10)
    }
  end


  # ajax paginator
  def user_page
    paginator_respond_as_js {
      return render text: '', status: :not_found unless @user
      @gists = Gist.where(user_id: @user.id).page(@page).per(10)
    }
  end

  # ajax paginator
  def user_fav_page
    paginator_respond_as_js {
      return render text: '', status: :not_found unless @user
      @favorites = Favorite.where(user_id: @user.id).page(@page).per(10)
    }
  end

  private

  def save_gist_and_redirect(gist_saver, failure_view_name)
    begin
      gist_files = params[:gist_file_names].zip(params[:gist_file_bodies])
      gist_saver.save!(@gist, gist_files, current_user)
      redirect_to @gist, notice: 'Successfully created.'
    rescue Exception => e
      debug_log_back_trace(e)
      render action: failure_view_name
    end
  end

  def set_paginator_params_to_fields
    @page = params[:page]
    @user = User.where(id: params[:user_id]).first
  end

  def respond_as_js
    respond_to { |format| format.js { yield }}
  end

  def paginator_respond_as_js
    respond_as_js {
      set_paginator_params_to_fields
      yield 
    }
  end

  def find_visible_gist_by_id(id, current_user)
    Gist.where(id: id).first || 
      Gist.find_my_gist_even_if_private(id, current_user.try(:id))
  end

  def is_path_param_gist_id_valid?
    @gist.id != params[:id].to_i
  end

  # private gists should be disclosed to only gist owner
  def is_not_visible_gist?
    @gist.user_id != current_user.try(:id) && !@gist.is_public
  end

end
