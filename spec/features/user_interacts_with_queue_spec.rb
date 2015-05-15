require 'spec_helper'

feature "User interacts with the queue" do
  scenario "User adds and reorders video in the queue" do
    comedies = Fabricate(:category, name: "comedies")
    monk = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    futurama = Fabricate(:video, title: "Futurama", category: comedies)
    
    sign_in
    add_video_to_queue(monk)
    expect(page).to have_content "My Queue"
    expect_video_to_be_in_queue(monk)
    
    click_link monk.title
    expect(page).to have_content monk.title
    expect_link_not_to_be_visible("+ My Queue")
    
    add_video_to_queue(south_park)
    add_video_to_queue(futurama)

    set_video_position(monk, 5)
    set_video_position(south_park, 4)
    click_button "Update Instant Queue"
    
    expect_video_position(futurama, 1)
    expect_video_position(south_park, 2)
    expect_video_position(monk, 3)
  end
  
  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end
  
  def expect_video_to_be_in_queue(video)
    expect(page).to have_content video.title
  end
  
  def expect_link_not_to_be_visible(link)
    expect(page).not_to have_content link
  end
  
  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end
  
  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end