class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(sign_up_options = {})
    stripe_token = sign_up_options[:stripe_token]
    invitation_token = sign_up_options[:invitation_token]

    if @user.valid?
      charge = charge_for_signup(stripe_token)

      if charge.successful?
        @user.save
        handle_invitation(invitation_token) if invitation_token.present?
        send_welcome_email
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
      end
    else
      @status = :failed
      @error_message = "Invalid user information. Please fix the errors below."
    end

    self
  end

  def successful?
    @status == :success
  end

  private

  def charge_for_signup(stripe_token)
    StripeWrapper::Charge.create(
      source: stripe_token,
      amount: 999,
      description: "Sign up charge for #{@user.email}"
    )
  end

  def subscribe_customer_to_monthly_payment_plan
    StripeWrapper::Customer.create(
      source: stripe_token,
      plan: "tomtl-myflix-monthly-plan",
      customer_email: @user.email
    )
  end

  def handle_invitation(invitation_token)
    invitation = Invitation.find_by(token: invitation_token)
    inviter = invitation.inviter
    @user.follow(inviter)
    inviter.follow(@user)
    invitation.update_column(:token, nil)
  end

  def send_welcome_email
    AppMailer.send_welcome_email(@user).deliver
  end
end
