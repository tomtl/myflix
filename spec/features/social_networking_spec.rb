require 'spec_helper'

feature 'User following' do
  scenario 'User follows and unfollows user' do
    user1 = Fabricate(:user)
    user2 = Fabricate(:user)
    comedies = Fabricate(:category, name: 'comedies')
    south_park = Fabricate(:video, title: 'South Park', category: comedies)
    review = Fabricate(:review, video: south_park, user: user2)

    sign_in(user1)
    visit home_path
    click_on_video_on_home_page(south_park)
    click_link user2.full_name
    click_link "Follow"
    expect(page).to have_content("People I Follow")
    expect(page).to have_content(user2.full_name)

    unfollow(user2)
    visit people_path
    expect(page).not_to have_content(user2.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end
