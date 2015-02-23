require 'rails_helper'

feature "Deleting comments" do

  background do
    @user = create(:user)
    @status = @user.statuses.create(content: "I want to go home.")
  end

  scenario "successfully deletes user's own comment", :js => true do
    log_in(@user)

    visit statuses_path
    expect(page).to have_content("I want to go home.")

    click_link '0 comments'

    fill_in 'comment_body', with: "I like that."

    click_button 'Comment'

    expect(page).to have_content("I like that.")

    click_link 'Delete'

    expect(page).to_not have_content("I like that.")
  end

end
