require "spec_helper"

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_16NpeDIgCm8hkqALIzitsnSX",
      "created" => 1436727477,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_16NpeDIgCm8hkqAL0Ju4lJt0",
          "object" => "charge",
          "created" => 1436727477,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16NpdeIgCm8hkqALGSefIEiO",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 7,
            "exp_year" => 2016,
            "fingerprint" => "wu7EphNce5e1xM1e",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "tokenization_method" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6aebQU7IVkT9ev"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_6aebQU7IVkT9ev",
          "invoice" => nil,
          "description" => "Charge to fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "destination" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_16NpeDIgCm8hkqAL0Ju4lJt0/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "req_6b1hNXWgQtdLLD",
      "api_version" => "2015-06-15"
    }
  end

  it "deactivates a user with a web hook user from Stripe", :vcr do
    Fabricate(:user, stripe_customer_id: "cus_6aebQU7IVkT9ev")
    post "/stripe_events", event_data
    expect(User.last).not_to be_active
  end
end
