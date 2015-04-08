require 'rails_helper'

feature "Creating friendship as user" do

  background do
    @user = create(:user)
    @user2 = create(:user)
    log_in(@user)
  end

  scenario "successfully creates a new friendship", :js => true do
    visit profile_path(@user2)
    click_link "Add Friend"
    expect(page).to have_content("Friendship Requested")
  end

  scenario "creates a mutual friendship with requested state", :js => true do
    visit profile_path(@user2)
    click_link "Add Friend"
    log_out(@user)
    log_in(@user2)
    visit profile_path(@user)
    expect(page).to have_content("Edit Friendship")
  end

end
