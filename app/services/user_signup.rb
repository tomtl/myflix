class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(sign_up_options = {})
    stripe_token = sign_up_options[:stripe_token]
    invitation_token = sign_up_options[:invitation_token]

    if @user.valid?
      subscription = subscribe_customer_to_monthly_payment_plan(stripe_token)

      if subscription.successful?
        add_user_stripe_customer_id(subscription)
        @user.save
        handle_invitation(invitation_token) if invitation_token.present?
        send_welcome_email
        @status = :success
      else
        @status = :failed
        @error_message = subscription.error_message
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

  def subscribe_customer_to_monthly_payment_plan(stripe_token)
    StripeWrapper::Customer.create(
      source: stripe_token,
      plan: "tomtl-myflix-monthly-plan",
      customer_email: @user.email
    )
  end

  def add_user_stripe_customer_id(subscription)
     @user.stripe_customer_id = subscription.stripe_customer_id
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
