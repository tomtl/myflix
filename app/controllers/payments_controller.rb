class PaymentsController < ApplicationController
  before_action :require_user
  
  def new
  end
  
  def create
    binding.pry
    Stripe.api_key = "sk_test_OyguaVei81Gg7bCwTjl5BO7l"

    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => 999, 
        :currency => "usd",
        :source => token,
      )
      flash[:success] = "Thanks! Your card has been charged."
      redirect_to new_payment_path
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_payment_path
    end
  end
end