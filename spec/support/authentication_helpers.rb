module AuthenticationHelpers

  module Feature
    def sign_in(user)
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button 'Log in'
    end

    def register_user
      visit "/"
      within ".navbar" do
        expect(page).to have_content("Register")
        click_link "Register"
      end

      fill_in "Name", with: "John"
      fill_in "Email", with: "jasmine@mail.com"
      fill_in "Password", with: "treebook666"
      fill_in "Confirm password", with: "treebook666"

      click_button "Register"
    end
  end

end
