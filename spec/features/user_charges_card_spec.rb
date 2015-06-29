require "spec_helper"

feature "User charges card", { js: true, vcr: true } do
  let(:user) { Fabricate.attributes_for(:user) }
  let(:valid_credit_card) { "4242424242424242" }
  let(:declined_credit_card) { "4000000000000002" }
  let(:expired_credit_card) { "4000000000000069" }
  let(:credit_card_with_incorrect_cvc) { "4000000000000127" }
  
  
  scenario "User registers with valid credit card successfully" do
    register_user(valid_credit_card)
    expect(charge).to be_successful
    expect(page).to have_content("You have registered successfully")
  end
  
  scenario "User's credit card is declined" do
    register_user(declined_credit_card)
    expect(charge).not_to be_successful
    expect(page).to have_content("The card was declined")
  end
  
  scenario "User's credit card is expired" do
    register_user(expired_credit_card)
    expect(charge).not_to be_successful
    expect(page).to have_content("The card has expired")
  end
  
  scenario "User's credit card has incorrect cvc number" do
    register_user(credit_card_with_incorrect_cvc)
    expect(charge).not_to be_successful
    expect(page).to have_content("The card's security code is incorrect")
  end
  
  def register_user(card_number)
    visit register_path
    fill_in "Email Address", with: user[:email]
    fill_in "Password", with: user[:password]
    fill_in "Full Name", with: user[:full_name]
    fill_in "Credit Card Number", with: card_number
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2020", from: "date_year"
    click_button "Sign Up"
  end
end