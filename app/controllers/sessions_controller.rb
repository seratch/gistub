# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  skip_before_filter :login_required

  skip_before_filter :nickname_required, :only => [:destroy]

  def start
    return_to = params[:return_to] || root_path
    redirect_to url_for("#{root_path}auth/open_id?return_to=#{return_to}")
  end

  def failure
    respond_to { |format| format.html }
  end

  def create
    auth = request.env["omniauth.auth"]
    if auth.present?
      user = User.where(:omniauth_provider => auth["provider"], :omniauth_uid => auth["uid"]).first ||
          User.create_with_omniauth(auth)
      session[:user_id] = user.id
      if params[:return_to].present?
        return redirect_to params[:return_to]
      end
    end
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to root_path
  end

end
