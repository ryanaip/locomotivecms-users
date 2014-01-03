require 'spec_helper'

feature "User interface" do
  background do
    setup_site
  end

  scenario "renders a page", js: true do
    visit '/locomotive'
    page.should have_content 'Log in'
  end
end
