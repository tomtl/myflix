require 'spec_helper'

feature 'User Resets Password' do
  scenario 'user successfully resets password' do
    user = Fabricate(:user, password: "old_password")
    visit sign_in_path
    click_link "Forgot password?"
    fill_in "Email address", with: user.email
    click_button "Send Email"

    open_email(user.email)
    current_email.click_link "Reset my password"

    fill_in "New password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: user.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"
    expect(page).to have_content("Welcome, #{user.full_name}")

    clear_email
  end
end
