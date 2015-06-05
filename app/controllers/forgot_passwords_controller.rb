class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user
      user.generate_token!
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      if params[:email].blank?
        flash[:error] = "Email can not be blank."
      else
        flash[:error] = "Incorrect email or password"
      end
      redirect_to forgot_password_path
    end
  end
end
