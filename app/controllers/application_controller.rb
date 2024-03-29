# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  
  def check_for_admin
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == 'admin' && password == 'adapt!'
    end if RAILS_ENV == 'production' || params[:admin_http]
  end
  
end
