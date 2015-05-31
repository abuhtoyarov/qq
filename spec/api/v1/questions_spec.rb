require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first}
      let!(:answer){ create(:answer, question:question)}

      before{get '/api/v1/questions', format: :json, access_token:access_token.token}

      it_behaves_like "API successful"

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'questions object content short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in questions object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', {format: :json}.merge(options)
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:attr) { attributes_for :question }
      let(:access_token) { create(:access_token) }
      let(:params) { { question: attr, format: :json, access_token: access_token.token } }

      before{post api_v1_questions_path, params }

      it_behaves_like "API successful"

      it 'created question' do
        expect(response).to be_created
      end

      it 'question saved in database' do
        expect{post api_v1_questions_path, params}.to change(Question, :count).by(1)
      end
    end

    def do_request(options = {})
      post api_v1_questions_path, {question: attributes_for(:question), format: :json}.merge(options)
    end
  end
end
