require 'rails_helper'

feature "Deleting statuses" do

  background do
    @user = create(:user)
    @admin = create(:admin)
    @status = @user.statuses.create(content: "I want to go home.")
  end

  scenario "successfully deletes the status as owner", :js => true do
    log_in(@user)

    visit statuses_path
    expect(page).to have_content("I want to go home.")

    within('.status-options') do
      click_link 'Options'
    end

    click_link 'Delete'

    expect(page).to_not have_content("I want to go home.")
  end

  scenario "successfully deletes statuses as admin", :js => true do
    log_in(@admin)

    visit statuses_path
    expect(page).to have_content("I want to go home.")

    within('.status-options') do
      click_link 'Options'
    end

    click_link 'Delete'

    expect(page).to_not have_content("I want to go home.")
  end

end
