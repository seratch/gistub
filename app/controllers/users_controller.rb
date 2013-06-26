# -*- encoding: utf-8 -*-
class UsersController < ApplicationController

  skip_before_filter :nickname_required, :only => [:edit, :update, :destroy]

  before_filter :login_required, :only => [:edit, :update, :destroy]

  respond_to :html

  def show
    @user = User.find(params[:id])
    @gists = Gist.where(:user_id => @user.id).page(1).per(10)
    @favorites = Favorite.where(:user_id => @user.id).page(1).per(10)
  end

  def edit
    if current_user.try(:id) == params[:id].to_i
      @user = User.find(params[:id])
      render action: "edit"
    else
      redirect_to root_path
    end
  end

  def update
    if current_user.try(:id) == params[:id].to_i
      @user = User.find(params[:id])
      if params[:user][:nickname].blank?
        flash[:notice] = "Nickname is required."
        return render action: "edit"
      end
      if @user.update_attributes(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render action: "edit"
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    if current_user.id == params[:id].to_i
      user = User.find(current_user.id)
      user.destroy
      reset_session
    end
    redirect_to root_path
  end

private

  def user_params
    params.require(:user).permit(:nickname)
  end

end
