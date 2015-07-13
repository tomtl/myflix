require "spec_helper"

feature "Admin views payments" do
  background do
    user1 = Fabricate(
      :user,
      email: "joe@example.com",
      full_name: "Joe Johnson"
    )
    Fabricate(:payment, user: user1, amount: 999)
  end

  scenario "admin can see payments" do
    admin = Fabricate(:admin)
    sign_in(admin)
    visit admin_payments_path

    expect(page).to have_content("$9.99")
    expect(page).to have_content("Joe Johnson")
    expect(page).to have_content("joe@example.com")
  end

  scenario "user can not see payments" do
    non_admin_user = Fabricate(:user)
    sign_in(non_admin_user)
    visit admin_payments_path

    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Joe Johnson")
    expect(page).to have_content("You do not have access to that page")
  end
end
