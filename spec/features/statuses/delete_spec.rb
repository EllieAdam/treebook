require 'rails_helper'

feature "Deleting statuses as user" do

  background do
    @user = create(:user)
    @user2 = create(:user)
    @status = Status.create(content: "I want to go home.", user_id: @user.id)
  end

  scenario "successfully deletes the status", :js => true do
    log_in(@user)
    expect(Status.count).to eq(1)
    expect(@status.user_id).to eq(@user.id)
    visit statuses_path

    expect(page).to have_content("I want to go home.")

    within "#statuses" do
      find('.status-options').click
      expect(page).to have_content('Delete')
      click_link 'Delete'
    end

    expect(page).to_not have_content("I want to go home.")
  end

end
