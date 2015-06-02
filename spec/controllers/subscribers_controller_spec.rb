require_relative '../../spec/acceptance/acceptance_helper'

RSpec.describe SubscribersController, type: :controller do
  let!(:question){ create(:question) }

  describe 'POST #create' do
    sign_in_user
    let!(:user) { create(:user) }

    it 'saved the new subscriber in the database' do
      expect{ post :create, question_id: question, user_id:@user, format: :js }.to change(Subscriber, :count).by(1)
    end

    it 'render create template' do
      post :create, question_id: question, user_id:@user, format: :js
      expect(response).to render_template :create
    end

    it 'Subscriber associated with question' do
      post :create, question_id: question, user_id:@user, format: :js
      expect(assigns(:subscriber)[:question_id]).to eq question.id
    end

    it 'Subscriber associated with user' do
      post :create, question_id: question, user_id:@user, format: :js
      expect(assigns(:subscriber)[:user_id]).to eq @user.id
    end

  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:subscriber) { create(:subscriber, user_id: @user.id) }

    it 'Delete subscriber' do
      subscriber
      expect{ delete :destroy, id:subscriber, format: :js }.to change(Subscriber, :count).by(-1)
    end

  end

end
