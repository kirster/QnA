require_relative '../acceptance_helper'

feature 'User signs up', %q{
  In order to ask questions and give answers
  As a guest
  I want to be able to sigh up
} do

  given(:user) { create(:user) }
  
  scenario 'Guest tries to sign up' do
    visit root_path
    click_on 'SignUp'
    fill_in 'Email', with: 'xyz@test.com'
    fill_in 'Password', with: '1234567'
    fill_in 'Password confirmation', with: '1234567'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end


  scenario 'Registered user tries to sign up' do
    sign_in(user)

    expect(page).to_not have_link 'SignUp'
  end

end
