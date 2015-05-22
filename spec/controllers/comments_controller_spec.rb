require_relative '../../spec/acceptance/acceptance_helper'

RSpec.describe CommentsController, type: :controller do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saved the new comment in the database' do

        expect { post :create, commentable: 'answers', answer_id: answer, comment: attributes_for(:comment), format: :js }.to change(answer.comments, :count).by(1)

      end

    end

  end
end
