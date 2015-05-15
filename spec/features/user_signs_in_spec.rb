require 'spec_helper'

feature "Signing in" do
  given(:user) { Fabricate(:user) }
  
  scenario "Signing in with correct crediatials" do
    visit sign_in_path
    fill_in "Email Address", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page). to have_content user.full_name
  end
end