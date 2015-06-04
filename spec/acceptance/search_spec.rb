require_relative 'acceptance_helper'

feature 'User may search content', %q{
        In order to be able search content
        As an user
        I want to be able search content
} do

  given!(:user) { create(:user, email: 'testsearch@tet.ru') }
  given!(:question) { create(:question, title: '123', body: '345') }
  given!(:answer) { create(:answer, question: question, body: 'test search') }
  given!(:comment_answer) { create(:comment, commentable:answer, body: 'test comment for answer')}
  given!(:comment_question) { create(:comment, commentable:question, body: 'test comment for question')}
  
  scenario 'search question', js: true do
    
    ThinkingSphinx::Test.run do
	  sign_in(user)
      
      select('Question', from: 'conditions')
      fill_in 'search', with: '123'
      click_on 'Search'

	  expect(page).to have_content  question.body
	  expect(page).to have_content  question.title
    end  
  end

  scenario 'search answer', js: true do
    
    ThinkingSphinx::Test.run do
	  sign_in(user)
      
      select('Answer', from: 'conditions')
      fill_in 'search', with: answer.body
      click_on 'Search'

	  expect(page).to have_content  answer.body
	  expect(page).to_not have_content  question.body
	  expect(page).to_not have_content  question.title
	  expect(page).to_not have_content  comment_question.body
	  expect(page).to_not have_content  comment_answer.body
    end  
  end 

  scenario 'search comment', js: true do
    
    ThinkingSphinx::Test.run do
	  sign_in(user)
      
      select('Comment', from: 'conditions')
      fill_in 'search', with: 'test comment'
      click_on 'Search'

	  expect(page).to_not have_content  answer.body
	  expect(page).to_not have_content  question.body
	  expect(page).to_not have_content  question.title
	  expect(page).to_not have_content  user.email
	  expect(page).to have_content  comment_question.body
	  expect(page).to have_content  comment_answer.body
    end  
  end

  scenario 'search user', js: true do
    
    ThinkingSphinx::Test.run do
	  sign_in(user)
      
      select('User', from: 'conditions')
      fill_in 'search', with: 'testsearch'
      click_on 'Search'

	  expect(page).to_not have_content  answer.body
	  expect(page).to_not have_content  question.body
	  expect(page).to_not have_content  question.title
	  expect(page).to have_content  'testsearch@tet.ru'
	  expect(page).to_not have_content  comment_question.body
	  expect(page).to_not	 have_content  comment_answer.body
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
	  expect(page).to have_content  comment_question.body
	  expect(page).to have_content  comment_answer.body
	 
    end  
  end
end