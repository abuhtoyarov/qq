require 'rails_helper'

describe 'Profiles API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it "return 401 status if there is no access token " do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it "return 401 status if access token is invalid" do
        get '/api/v1/profiles/me', format: :json, access_token:1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me){ create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before{get '/api/v1/profiles/me', format: :json, access_token:access_token.token}

      it 'return 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at).each do |attr|
        it 'content email' do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "content #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /users' do
    context 'unauthorized' do
      it "return 401 status if there is no access token " do
        get '/api/v1/profiles/users', format: :json
        expect(response.status).to eq 401
      end

      it "return 401 status if access token is invalid" do
        get '/api/v1/profiles/users', format: :json, access_token:1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me){ create(:user) }
      let!(:users){ create_list(:user, 2) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before{get '/api/v1/profiles/users', format: :json, access_token:access_token.token}

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'contains users list' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'without current_user' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end
  end
end