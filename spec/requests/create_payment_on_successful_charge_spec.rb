require "spec_helper"

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_16N86nIgCm8hkqALV2pNqfV9",
      "created" => 1436560113,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_16N86mIgCm8hkqALgUEwkEft",
          "object" => "charge",
          "created" => 1436560112,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16N86lIgCm8hkqALB2VGoQPc",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 7,
            "exp_year" => 2016,
            "fingerprint" => "Co17IYkKBYatKAgX",
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
            "customer" => "cus_6aIi0dvRVgO0ag"
          },
          "captured" => true,
          "balance_transaction" => "txn_16N86mIgCm8hkqALHLj7BjGw",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_6aIi0dvRVgO0ag",
          "invoice" => "in_16N86mIgCm8hkqALlb1RKNgj",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => "Myflix subscription",
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
            "url" => "/v1/charges/ch_16N86mIgCm8hkqALgUEwkEft/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "req_6aIiQPk5CNz3uq",
      "api_version" => "2015-06-15"
    }
  end

  it "creates payment with webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    user1 = Fabricate(:user, stripe_customer_id: "cus_6aIi0dvRVgO0ag")
    post "/stripe_events", event_data
    expect(Payment.last.user).to eq(user1)
  end

  it "creates the payment with the amount", :vcr do
    Fabricate(:user, stripe_customer_id: "cus_6aIi0dvRVgO0ag")
    post "/stripe_events", event_data
    expect(Payment.last.amount).to eq(999)
  end

  it "creates the payment with the reference_id", :vcr do
    Fabricate(:user, stripe_customer_id: "cus_6aIi0dvRVgO0ag")
    post "/stripe_events", event_data
    expect(Payment.last.reference_id).to eq("ch_16N86mIgCm8hkqALgUEwkEft")
  end
end
