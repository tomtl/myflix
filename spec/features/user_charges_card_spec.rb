require "spec_helper"

feature "User charges card", :js, :vcr do
  let(:valid_user) { Fabricate.attributes_for(:user) }
  let(:invalid_user) { Fabricate.attributes_for(:user, email: nil) }
  let(:valid_credit_card) { "4242424242424242" }
  let(:invalid_credit_card) { "1234" }
  let(:declined_credit_card) { "4000000000000002" }
  let(:expired_credit_card) { "4000000000000069" }
  let(:credit_card_with_incorrect_cvc) { "4000000000000127" }

  after { ActionMailer::Base.deliveries.clear }

  scenario "User registers with valid user info and credit card successfully" do
    register_user(valid_user, valid_credit_card)
    expect(page).to have_content("You have registered successfully")
  end

  scenario "Valid user info and invalid card number" do
    register_user(valid_user, invalid_credit_card)
    expect(page).to have_content("This card number looks invalid")
  end

  scenario "Valid user info and declined credit card" do
    register_user(valid_user, declined_credit_card)
    expect(page).to have_content("Your card was declined")
  end

  scenario "Valid user info and expired credit card" do
    register_user(valid_user, expired_credit_card)
    expect(page).to have_content("Your card has expired")
  end

  scenario "Valid user info and incorrect card cvc number" do
    register_user(valid_user, credit_card_with_incorrect_cvc)
    expect(page).to have_content("Your card's security code is incorrect")
  end

  scenario "Invalid user info and valid credit card" do
    register_user(invalid_user, valid_credit_card)
    expect(page).to have_content("Please fix the following errors")
  end

  scenario "Invalid user info and invalid credit card" do
    register_user(invalid_user, invalid_credit_card)
    expect(page).to have_content("This card number looks invalid")
  end

  scenario "Invalid user info and declined card" do
    register_user(invalid_user, declined_credit_card)
    expect(page).to have_content("Please fix the following errors")
  end

  def register_user(user, card_number)
    visit register_path
    fill_in "Email Address", with: user[:email]
    fill_in "Password", with: user[:password]
    fill_in "Full Name", with: user[:full_name]
    fill_in "Credit Card Number", with: card_number
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2018", from: "date_year"
    click_button "Sign Up"
  end
end
