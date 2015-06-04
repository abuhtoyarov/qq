require_relative 'acceptance_helper'

feature 'User may search content', %q{
        In order to be able search content
        As an user
        I want to be able search content
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: '123', body: '345') }
  given!(:answer) { create(:answer, question: question, body: 'test search') }
  
  scenario 'search selected item', js: true do
    
    ThinkingSphinx::Test.run do
	  sign_in(user)
      
      select('Question', from: 'conditions')
      fill_in 'search', with: '123'
      click_on 'Search'
    
	  expect(page).to have_content  question.body
	  expect(page).to have_content  question.title
    end  
  end

  scenario 'search all', js: true do
    
    ThinkingSphinx::Test.run do
	  sign_in(user)
      
      select('All', from: 'conditions')
      fill_in 'search', with: ''
      click_on 'Search'

	  expect(page).to have_content  user.email
	  expect(page).to have_content  question.title
	  expect(page).to have_content  answer.body
    end  
  end


end