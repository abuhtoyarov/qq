  require_relative "acceptance_helper"

feature 'Add attachments to answer', %q{
        In order to be able add attachments to answer
        As an author answer
        I want to be able add attachments to answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'Authenticated user (Author answer) add attachments to answer', js: true do
    fill_in 'Body', with: 'body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Answer'

    expect(page).to have_link 'rails_helper.rb'
  end

  scenario 'Authenticated user (Author answer) add two attachments to answer', js: true do
    fill_in 'Body', with: 'body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Add attachment'

    next_file =  all('.new_answer .fields').last
    next_file.attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Answer'

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end

end