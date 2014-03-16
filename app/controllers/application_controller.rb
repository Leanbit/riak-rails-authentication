class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def authenticate_user!
      redirect_to root_path, notice: 'You Must login' unless current_user
    end

  helper_method :current_user, :authenticate_user!
end
