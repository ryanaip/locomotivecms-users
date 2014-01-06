require 'spec_helper'

feature "Content entry user interface" do
  background do
    setup_site
  end

  shared_examples_for "a set of login pages" do
    let(:email) { 'myemail@example.com' }
    let(:password) { 'mypassword' }

    scenario "renders the sign in page" do
      visit "/#{type}/sign_in"
      expect(page).to have_content 'Sign in'
    end

    context "visiting the signup page" do
      let!(:user_count) { Locomotive::ContentEntry.count }

      background do
        clear_emails
        visit "/#{type}/sign_up"
      end

      scenario "renders the sign up page" do
        expect(page).to have_content 'Sign up'
      end

      context "and signing up" do
        let(:user) { Locomotive::ContentEntry.last }

        background do
          fill_in "Email", with: email
          fill_in "Password", with: password
          fill_in "Password confirmation", with: password

          click_on("Sign up")
          open_email(email)
        end

        scenario "creates a user" do
          expect(page.status_code).to eq 200
          expect(Locomotive::ContentEntry.count).to eq user_count+1
          expect(user.email).to eq email
        end

        scenario "sends a confirmation" do
          expect(current_email).to be_present
          current_email.click_link('Confirm my account')
          expect(page).to have_content('Your account was successfully confirmed.')
        end
      end
    end
  end

  context "for editors" do
    let(:type) { 'editors' }
    it_behaves_like "a set of login pages"
  end

  context "for writers" do
    let(:type) { 'writers' }
    it_behaves_like "a set of login pages"
  end

  context "for an invalid type" do
    scenario "does not render the sign in page", js: true do
      visit "/invalid/sign_in"
      expect(page.status_code).to equal 404
    end
  end
end
