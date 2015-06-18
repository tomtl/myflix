class AdminsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin
  
  private
    def require_admin
      if !current_user.admin
        flash[:error] = "You do not have access to that page."
        redirect_to root_path
      end
    end
end