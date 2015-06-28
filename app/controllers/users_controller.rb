class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])

    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      handle_invitation if params[:invitation_token].present?

      charge = StripeWrapper::Charge.create(
        amount: 999,
        source: params[:stripeToken],
        description: "Sign up charge for #{@user.email}"
      )
      # if charge.successful?
      #   flash[:success] = "Thanks, your payment has been processed successfully"
      # else
      #   flash.now[:error] = charge.error_message
      #   render :new and return
      # end

      AppMailer.send_welcome_email(@user).deliver
      flash[:success] = "You have registered successfully"
      session[:user_id] = @user.id
      redirect_to home_path
    else
      flash.now[:error] = "Please fix the following errors"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def handle_invitation
    invitation = Invitation.find_by(token: params[:invitation_token])
    inviter = invitation.inviter
    @user.follow(inviter)
    inviter.follow(@user)
    invitation.update_column(:token, nil)
  end
end
