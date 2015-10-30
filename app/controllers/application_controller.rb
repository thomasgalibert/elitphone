class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_company
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = t('form.non_authorized')
    redirect_to login_url
  end

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_company
      @current_company ||= current_user.company if current_user
    end
end
