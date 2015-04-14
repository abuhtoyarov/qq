require_relative "acceptance_helper"

feature 'Add attachments to question', %q{
        In order to be able add attachments to question
        As an author question
        I want to be able add attachments to question
} do

  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'Authenticated user (Author question) add attachments to question', js: true do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create question'

    expect(page).to have_link 'rails_helper.rb'
  end

    scenario 'Authenticated user (Author answer) add two attachments to question', js: true do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'body'
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Add attachment'

      next_file =  all('.new_question .fields').last
      next_file.attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Create question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
  end
end