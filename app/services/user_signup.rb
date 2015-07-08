class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999,
        source: stripe_token,
        description: "Sign up charge for #{@user.email}"
      )
      if charge.successful?
        @user.save
        handle_invitation(invitation_token) if invitation_token.present?
        AppMailer.send_welcome_email(@user).deliver
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
      end
    else
      @status = :failed
      @error_message = "Invalid user information. Please fix the errors below."
    end
    return self
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    invitation = Invitation.find_by(token: invitation_token)
    inviter = invitation.inviter
    @user.follow(inviter)
    inviter.follow(@user)
    invitation.update_column(:token, nil)
  end
end
