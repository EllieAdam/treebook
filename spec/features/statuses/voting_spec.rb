require 'rails_helper'

feature "Upvoting" do
  background do
    @user = create(:user)
    @status = create(:status, user: @user)
    log_in(@user)
  end

  scenario "increases the number of upvotes", :js => true do
    visit statuses_path
    within('.text-success') do
      expect(page).to have_content('0')
    end
    within('.text-danger') do
      expect(page).to have_content('0')
    end

    click_link "Upvote"

    within('.text-success') do
      expect(page).to have_content('1')
    end
    within('.text-danger') do
      expect(page).to have_content('0')
    end
  end

  scenario "removes the upvote when clicked again", :js => true do
    visit statuses_path

    click_link "Upvote"

    within('.text-success') do
      expect(page).to have_content('1')
    end

    click_link "Upvote"

    within('.text-success') do
      expect(page).to have_content('0')
    end
    within('.text-danger') do
      expect(page).to have_content('0')
    end
  end

  scenario "removes the downvote and increases upvotes", :js => true do
    visit statuses_path

    click_link "Downvote"

    within('.text-success') do
      expect(page).to have_content('0')
    end
    within('.text-danger') do
      expect(page).to have_content('1')
    end

    click_link "Upvote"

    within('.text-success') do
      expect(page).to have_content('1')
    end
    within('.text-danger') do
      expect(page).to have_content('0')
    end
  end
end

feature "Downvoting" do
  background do
    @user = create(:user)
    @status = create(:status, user: @user)
    log_in(@user)
  end

  scenario "increases the number of downvotes", :js => true do
    visit statuses_path
    within('.text-success') do
      expect(page).to have_content('0')
    end
    within('.text-danger') do
      expect(page).to have_content('0')
    end

    click_link "Downvote"

    within('.text-success') do
      expect(page).to have_content('0')
    end
    within('.text-danger') do
      expect(page).to have_content('1')
    end
  end

  scenario "removes the downvote when clicked again", :js => true do
    visit statuses_path

    click_link "Downvote"

    within('.text-danger') do
      expect(page).to have_content('1')
    end

    click_link "Downvote"

    within('.text-success') do
      expect(page).to have_content('0')
    end
    within('.text-danger') do
      expect(page).to have_content('0')
    end
  end

  scenario "removes the upvote and increases downvotes", :js => true do
    visit statuses_path

    click_link "Upvote"

    within('.text-success') do
      expect(page).to have_content('1')
    end
    within('.text-danger') do
      expect(page).to have_content('0')
    end

    click_link "Downvote"

    within('.text-success') do
      expect(page).to have_content('0')
    end
    within('.text-danger') do
      expect(page).to have_content('1')
    end
  end
end
