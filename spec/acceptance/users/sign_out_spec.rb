require 'rails_helper'

feature 'User signs out', %q{
  In order to finish session 
  As an authenticated user
  I want to be able to sigh out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user signs out' do
    sign_in(user)

    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-Authenticated user tries to sign out' do
    visit root_path

    expect(page).to_not have_link 'Logout'
  end

end