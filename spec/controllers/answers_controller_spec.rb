require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question){ create(:question) }
  let(:answer) {create(:answer, question: question)}

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saved the new answer in the database' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end
      it 'redirect to show view' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
        expect(response).to redirect_to question_path(assigns(:question))
      end
      it 'Answer associated with question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(assigns(:answer)[:question_id]).to eq question.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect{ post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end
      it 'redirect to show view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to redirect_to question_path(assigns(:question))
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
      expect{ delete :destroy, id:answer, question_id: question }.to change(question.answers, :count).by(-1)
    end

    it 'Redirect to show' do
      delete :destroy, id:answer, question_id: question
      expect(response).to redirect_to question_path(assigns(:question))
    end

  end

end
