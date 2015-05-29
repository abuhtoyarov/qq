require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    context 'unauthorized' do
      let!(:question) { create :question }

      it "return 401 status if there is no access token " do
        get api_v1_question_answers_path(question), format: :json
        expect(response.status).to eq 401
      end

      it "return 401 status if access token is invalid" do
        get api_v1_question_answers_path(question), format: :json, access_token:1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create :question }
      let!(:answers) { create_list(:answer,2, question:question) }
      let!(:answer) { question.answers.first}

      before{get api_v1_question_answers_path(question), format: :json, access_token: access_token.token}

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answer' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:answer) { create(:answer) }

    it "return 401 status if there is no access token " do
      get api_v1_answer_path(answer), format: :json
      expect(response.status).to eq 401
    end

    it "return 401 status if access token is invalid" do
      get api_v1_answer_path(answer), format: :json, access_token:1234
      expect(response.status).to eq 401
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachments) { create(:attachment, attachable: answer) }

      before{get api_v1_answer_path(answer), format: :json, access_token: access_token.token}

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it "include in answer object" do
            expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it "include in answer object" do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it "contains url" do
           expect(response.body).to be_json_eql(attachments.file.url.to_json).at_path("answer/attachments/0/file/file/url")
         end

      end
    end
  end

  describe 'POST /create' do
    let!(:question) { create :question }

    context 'unauthorized' do
      it "return 401 status if there is no access token " do
        post api_v1_question_answers_path(question), format: :json
        expect(response.status).to eq 401
      end

      it "return 401 status if access token is invalid" do
        post api_v1_question_answers_path(question), format: :json, access_token:1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:attr) { attributes_for :answer }
      let(:access_token) { create(:access_token) }
      let(:params) { { answer: attr, format: :json, access_token: access_token.token } }
      let(:post_create) { post api_v1_question_answers_path(question), params }

      it 'returns 201 status code' do
        post_create
        expect(response.status).to eq 201
      end

      it 'answer created' do
        post_create
        expect(response).to be_created
      end

      it 'answer saved in database' do
        expect{post_create}.to change(Answer, :count).by(1)
      end
    end
  end
end