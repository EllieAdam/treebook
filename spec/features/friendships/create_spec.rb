require 'rails_helper'

feature "Creating friendship as user" do

  background do
    @user = create(:user)
    @user2 = create(:user)
    log_in(@user)
  end

  scenario "successfully creates a new friendship" do
    expect(Friendship.count).to eq(0)
    visit profiles_path(@user2)
    expect(page).to have_content("Add Friend")
    click_link "Add Friend"
    expect(page).to have_content("Are you sure you want to request this friend?")
    click_button "Yes, add friend"
    expect(page).to have_content("You are now friends with #{@user2.name}")
    expect(Friendship.count).to eq(1)
  end

end
