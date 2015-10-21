class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "#{t('session.flash.login')} #{user.firstname} !!"
      redirect_to events_path
    else
      flash[:warning] = t('session.flash.error')
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = t('session.flash.logout')
    redirect_to login_url
  end
end
