class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You have registered successfully"
      redirect_to sign_in_path
    else
      flash[:error] = "There was an error."
      render :new
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end