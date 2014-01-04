require 'spec_helper'

feature "Content entry as users" do
  background do
    setup_site
  end

  scenario "renders the signin form for writers", js: true do
    visit "/writers/sign_in"
    page.should have_content "password"
  end

  scenario "renders the signin form for editors", js: true do
    visit "/editors/sign_in"
    page.should have_content "password"
  end
end
