require_relative '../acceptance_helper'

feature 'Adding files to answer', %q{
  In order to illustrate my answer
  As an answers's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User adds file when gives answer', js: true do
    fill_in 'answer[body]', with: 'Test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end 
  end

  scenario 'User can add several files to answer', js: true do
    fill_in 'answer[body]', with: 'Test answer'
    click_on 'Add file'

    file_inputs = all('input[type="file"]')
    file_inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    file_inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end        
  end 

end