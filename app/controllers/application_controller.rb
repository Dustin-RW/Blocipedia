class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Pundit
  include SessionsHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Access denied"
    redirect_to (request.referrer || root_path)
  end

  def require_sign_in
  # if you are not signed in as a current_user via Session, return to new_session_path
  # with an alert
  unless current_user
    flash[:alert] = 'You must be logged in to do that'

    redirect_to root_path
  end
end

end
