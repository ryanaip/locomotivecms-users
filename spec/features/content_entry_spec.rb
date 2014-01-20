require 'spec_helper'

feature "Content entry user interface" do
  background do
    setup_site

    keys = ::Devise.mappings.keys.reject{ |k| k == :locomotive_account }
    keys.each { |key| ::Devise.mappings.delete(key) }
    Locomotive::ContentType.refresh_devise_mappings!
  end

  def url(path)
    "http://#{site}.lvh.me:7171#{path}"
  end

  shared_examples_for "a set of login pages" do
    let(:email) { 'myemail@example.com' }
    let(:password) { 'mypassword' }

    scenario "renders the sign in page" do
      visit url("/#{type}/sign_in")
      expect(page).to have_content 'Sign in'
    end

    context "visiting the signup page" do
      let!(:user_count) { Locomotive::ContentEntry.count }

      background do
        clear_emails
        visit url("/#{type}/sign_up")
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

          click_on "Sign up"
          open_email(email)
        end

        scenario "creates a user" do
          expect(page.status_code).to eq 200
          expect(Locomotive::ContentEntry.count).to eq user_count+1
          expect(user.email).to eq email
        end

        scenario "sends a confirmation" do
          expect(current_email).to be_present

          # Can't just use click_link because we may be on a subdomain, and
          # click_link ignores the host name in these links.
          link = current_email.find_link('Confirm my account')
          visit link[:href]

          expect(page).to have_content('Your account was successfully confirmed.')
        end

        scenario "allows sign in" do
          user.confirm!
          visit url("/#{type}/sign_in")
          fill_in "Email", with: email
          fill_in "Password", with: password

          click_on "Sign in"

          visit url("/status")
          expect(page).to have_content("Logged in as #{type.singularize} with email #{email}")
        end
      end
    end
  end

  context "for the main site" do
    let(:site) { 'test' }

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

  context "for a different site" do
    let(:site) { 'test2' }

    context "for editors (that do exist)" do
      let(:type) { 'editors' }
      let(:primary_site) { Locomotive::Site.where(subdomain: 'test').first }
      let(:primary_writer_type) do
        Locomotive::ContentType.where(site: primary_site, name: 'Editors').first
      end

      let(:email) { 'testemail@example.com' }
      let(:password) { 'password' }
      let(:first_name) { 'Jonny' }

      let!(:primary_user) do
        user = primary_writer_type.entries.create(
          email: email,
          first_name: first_name,
          password: password,
          password_confirmation: password
        )
        user.confirm!

        user
      end

      it_behaves_like "a set of login pages"

      it "doesn't allow logins from the other site" do
        visit url("/#{type}/sign_in")
        fill_in "Email", with: email
        fill_in "Password", with: password

        click_on "Sign in"

        visit url("/status")
        expect(page).not_to have_content("Logged in as #{type.singularize} with email #{email}")
      end
    end

    context "for writers (that don't exist)" do
      let(:type) { 'writers' }
      it "doesn't find anything" do
        visit url("/#{type}/sign_in")
        expect(page.status_code).to be(404)
      end

      it "passes through to pages that exist" do
        visit url("/#{type}")
        expect(page).to have_content('CMS Writers Page')
      end
    end
  end
end
