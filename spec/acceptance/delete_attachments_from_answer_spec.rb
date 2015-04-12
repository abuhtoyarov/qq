require_relative "acceptance_helper"

feature 'Delete attachments from answer', %q{
        In order to be able delete attachments from answer
        As an author answer
        I want to be able add attachments to answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in user
    visit question_path(question)
    fill_in 'Body', with: 'body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Answer'
  end

  scenario 'Authenticated user (Author answer) delete attachments from answer', js: true do
    within '.Attachments' do
      click_on 'Delete'
    end

    expect(page).to_not have_link 'rails_helper.rb'
  end
end