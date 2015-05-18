require_relative '../../spec/acceptance/acceptance_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question){ create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:accepted_answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saved the new answer in the database' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(Answer, :count).by(1)
      end
      it 'redirect to show view' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(Answer, :count).by(1)
        expect(response).to render_template :create
      end
      it 'Answer associated with question' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)[:question_id]).to eq question.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect{ post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
      it 'redirect to show view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'GET #new' do
    sign_in_user

    before{ get :new, question_id:question }

    it 'Assign a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    it 'Delete answer' do
      answer
      expect{ delete :destroy, id:answer, question_id: question, format: :js }.to change(question.answers, :count).by(-1)
    end

    it 'Redirect to show' do
      delete :destroy, id:answer, question_id: question, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: {body: 'new body'} , format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end

    it 'Accepted answer' do
      patch :accept, id: answer, question_id: question, answer: {body: 'new body', best: true} , format: :js
      answer.reload
      expect(answer.best).to eq true
    end

    it 'Replace accept answer' do
        patch :accept, id: accepted_answer, question_id: question, answer: {body: 'new body', best: true} , format: :js
        accepted_answer.reload
        expect(accepted_answer.best).to eq true
        patch :accept, id: answer, question_id: question, answer: {body: 'new body123', best: true} , format: :js
        answer.reload
        expect(answer.best).to eq true
        accepted_answer.reload
        expect(accepted_answer.best).to_not eq true
    end

    it 'Like answer' do
      patch :like, id: answer, question_id: question, answer: {body: 'new body'} , format: :js
      answer.reload
      expect(answer.rating).to eq 1
    end

    it 'DisLike answer' do
      patch :dislike, id: answer, question_id: question, answer: {body: 'new body'} , format: :js
      answer.reload
      expect(answer.rating).to eq -1
    end

    it 'Unvote answer' do
      patch :like, id: answer, question_id: question, answer: {body: 'new body'} , format: :js
      expect(answer.rating).to eq 1
      patch :unvote, id: answer, question_id: question, answer: {body: 'new body'} , format: :js
      answer.reload
      expect(answer.rating).to eq 0
    end
  end
end
