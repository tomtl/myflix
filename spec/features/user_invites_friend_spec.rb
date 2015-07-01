require "spec_helper"

feature "User invites friend" do
  scenario "User successfully invites friend and invitation is accepted", :js, :vcr do
    @user = Fabricate(:user)
    @friend = Fabricate.attributes_for(:user)
    sign_in(@user)

    invite_a_friend
    friend_accepts_invitation

    # check_friend_is_following_user
    check_user_is_following_friend
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: @friend[:full_name]
    fill_in "Friend's Email Address", with: @friend[:email]
    fill_in "Message", with: "Want to join Myflix?"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email @friend[:email]
    current_email.click_link "Access this invitation"
    fill_in "Password", with: @friend[:password]
    fill_in "Full Name", with: @friend[:full_name]
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2018", from: "date_year"
    click_button "Sign Up"
    sleep(1)
  end

  def check_friend_is_following_user
    visit people_path
    expect(page).to have_content(@user.full_name)
  end

  def check_user_is_following_friend
    visit sign_out_path
    sign_in(@user)
    visit people_path
    expect(page).to have_content(@friend[:full_name])
  end
end
