class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password]) && user.active
      session[:user_id] = user.id
      redirect_to home_path, notice: "Welcome #{user.full_name}! You are signed in."
    elsif user && user.active == false
      flash[:error] = "Your account has been suspended, please contact customer service."
      redirect_to sign_in_path
    else
      flash[:error] = "Invalid email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You are signed out."
  end
end