require 'spec_helper'

feature "Signing in" do
  given(:user) { Fabricate(:user) }

  scenario "Signing in with correct credentials" do
    sign_in(user)
    expect(page).to have_content user.full_name
  end

  scenario "Signing in with incorrect credentials" do
    visit sign_in_path
    fill_in "Email Address", with: user.email
    fill_in "Password", with: "#{user.password}abcd"
    click_button "Sign in"
    expect(page).to have_content "Invalid email or password"
  end

  scenario "with deactivated user" do
    deactivated_user = Fabricate(:user, active: false)
    sign_in(deactivated_user)
    expect(page).not_to have_content(user.full_name)
    expect(page).to have_content("Your account has been suspended, please contact customer service.")
  end
end