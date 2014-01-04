# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base

  protect_from_forgery

  before_action :load_current_user, :nickname_required

  helper_method [:current_user, :anonymous_allowed]

  private

  def render_404
    render file: "#{Rails.root}/public/404", formats: [:html], status: 404
  end

  def anonymous_allowed
    Gistub::Application.config.gistub_allows_anonymous
  end

  def nickname_required
    if current_user.present? && current_user.nickname.nil?
      redirect_to edit_user_path(current_user)
    end
  end

  def login_required
    redirect_to signin_path(return_to: request.url) if current_user.blank?
  end

  def load_current_user
    if @cached_current_user.present?
      @cached_current_user
    else
      begin
        @cached_current_user = session[:user_id].present? ? User.find(session[:user_id]) : nil
      rescue Exception => e 
        Rails.logger.debug e
        reset_session
        nil
      end
    end
  end

  def current_user
    @cached_current_user
  end

  def destroy_and_redirect_to_gist(active_record_model, success_notice, failure_notice)
    gist_id = params[:gist_id]
    if active_record_model.present?
      active_record_model.destroy
      redirect_to gist_path(gist_id), notice: success_notice
    else
      redirect_to gist_path(gist_id), notice: failure_notice
    end
  end

  def debug_log_back_trace(e)
    Rails.logger.debug e.backtrace.join("\n")
  end

end
