require_relative '../../spec/acceptance/acceptance_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question){ create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:accepted_answer) { create(:answer, question: question) }
  let(:channel) { "/questions/#{question.id}/answers" }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:params) {{ question_id:question.id, answer: attributes_for(:answer), format: :json }}

      it 'saved the new answer in the database' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer), format: :json }.to change(Answer, :count).by(1)
      end

      it 'render to show view' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer), format: :json }.to change(Answer, :count).by(1)
        expect(response).to render_template :submit
      end

      it 'Answer associated with question' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :json
        expect(assigns(:answer)[:question_id]).to eq question.id
      end

      it_behaves_like "PrivatePub publishable"

    end

    context 'with invalid attributes' do
      let(:params) {{ question_id:question.id, answer: attributes_for(:invalid_answer), format: :json }}

      it 'does not save the question' do
        expect{ post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'redirect to show view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end

      it_behaves_like "PrivatePub not publishable"

    end

    def do_request
      post :create, params
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
      answer.update(user_id: @user.id)
      expect{ delete :destroy, id:answer, question_id: question, format: :js }.to change(question.answers, :count).by(-1)
    end

    it 'Render template' do
      answer.update(user_id: @user.id)
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
      answer.update(user_id: @user.id)
      patch :update, id: answer, question_id: question, answer: {body: 'new body'} , format: :json
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      answer.update(user_id: @user.id)
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end

    it 'Accepted answer' do
      question.update(user_id: @user.id)
      patch :accept, id: answer, question_id: question, answer: {body: 'new body', best: true} , format: :js
      answer.reload
      expect(answer.best).to eq true
    end

    it 'Replace accept answer' do
      question.update(user_id: @user.id)
      patch :accept, id: accepted_answer, question_id: question, answer: {body: 'new body', best: true} , format: :js
      accepted_answer.reload
      expect(accepted_answer.best).to eq true
      patch :accept, id: answer, question_id: question, answer: {body: 'new body123', best: true} , format: :js
      answer.reload
      expect(answer.best).to eq true
      accepted_answer.reload
      expect(accepted_answer.best).to_not eq true
    end
  end

  describe 'PATCH #upvote' do
    context 'authencticated user' do
      sign_in_user

      it 'upvote answer' do
        expect{patch :like, id: answer, question_id: question, format: :js}.to change(answer, :rating).by(1)
      end

      it 'repeat upvote answer' do
        expect{patch :like, id: answer, question_id: question, format: :js}.to change(answer, :rating).by(1)
        expect{patch :like, id: answer, question_id: question, format: :js}.to_not change(answer, :rating)
      end

      it 'upvote answer as author' do
        answer.update(user_id: @user.id)
        expect{patch :like, id: answer, question_id: question, format: :js}.to_not change(answer, :rating)
      end
    end
    
    context 'non-authencticated user' do
      it 'upvote answer' do
        expect{patch :like, id: answer, question_id: question, format: :js}.to_not change(answer, :rating)
      end
    end    
  end

  describe 'PATCH #downvote' do
    context 'authencticated user' do
      sign_in_user

      it 'downvote answer' do
        expect{patch :dislike, id: answer, question_id: question, format: :js}.to change(answer, :rating).by(-1)
      end

      it 'repeat downvote answer' do
        expect{patch :dislike, id: answer, question_id: question, format: :js}.to change(answer, :rating).by(-1)
        expect{patch :dislike, id: answer, question_id: question, format: :js}.to_not change(answer, :rating)
      end

      it 'downvote answer as author' do
        answer.update(user_id: @user.id)
        expect{patch :dislike, id: answer, question_id: question, format: :js}.to_not change(answer, :rating)
      end
    end
    
    context 'non-authencticated user' do
      it 'downvote answer' do
        expect{patch :dislike, id: answer, question_id: question, format: :js}.to_not change(answer, :rating)
      end
    end    
  end

  describe 'PATCH #unvote' do
      sign_in_user

      it 'unvote answer' do
        patch :dislike, id: answer, question_id: question, format: :js
        expect{patch :unvote, id: answer, question_id: question, format: :js}.to change(answer, :rating).by(1)
        patch :like, id: answer, question_id: question, format: :js
        expect{patch :unvote, id: answer, question_id: question, format: :js}.to change(answer, :rating).by(-1)
      end  
  end    
end
