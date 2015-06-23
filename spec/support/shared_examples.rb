shared_examples "requires sign in" do
  it "redirects to the sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "requires admin" do
  it "redirects to the sign in page for regular user" do
    user = Fabricate(:user, admin: false)
    set_current_user(user)
    action
    expect(response).to redirect_to root_path
  end

  it "displays error message for regular user" do
    user = Fabricate(:user, admin: false)
    set_current_user(user)
    action
    expect(flash[:error]).to be_present
  end
end
