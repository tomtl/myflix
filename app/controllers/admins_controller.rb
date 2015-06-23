class AdminsController < ApplicationController
  before_action :require_user
  before_action :require_admin

  private
    def require_admin
      unless current_user.admin?
        flash[:error] = "You do not have access to that page."
        redirect_to root_path
      end
    end
end
