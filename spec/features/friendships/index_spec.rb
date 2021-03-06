require 'rails_helper'

feature "Friendship index page" do

  background do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
    @friendship1 = create(:pending_friendship, user: @user1, friend: @user2)
    @friendship2 = create(:accepted_friendship, user: @user1, friend: @user3)
    @friendship3 = create(:pending_friendship, user: @user2, friend: @user3)
    @friendship3 = create(:requested_friendship, user: @user2, friend: @user3)
    log_in(@user1)
  end

  scenario "shows all logged-in user's friendships" do
    visit friendships_path
    expect(page).to have_content("Pending")
    expect(page).to have_content("Accepted")
    expect(page).to have_content("Requested")
  end

end
