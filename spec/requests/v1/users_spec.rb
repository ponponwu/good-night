require 'swagger_helper'

RSpec.describe 'v1/users', type: :request do

  path '/v1/users/{id}/follow' do
    parameter name: 'id', in: :path, type: :integer, description: 'user id'
    parameter name: :params, in: :body, schema: {
      type: :object,
      properties: {
        user: {
          type: :object,
          properties: {
            followee_id: { type: :integer }
          },
          required: %w(followee_id),
        },
      },
      required: %w(user),
    }

    post('follow your friend') do
      consumes "application/json"
      produces "application/json"
      tags "Users"
      let!(:followee_id) { create(:user).id }
      let!(:follower_id) { create(:user).id }
      let(:id) { follower_id }
      response(200, 'successful') do  
        let(:params) do
          {
            id: id,
            user: {
              followee_id: followee_id
            }
          }
        end
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          expect(JSON.parse(response.body)['data']).not_to eq(nil)
          expect(JSON.parse(response.body)['data']['follower_id']).to eq(follower_id)
          expect(JSON.parse(response.body)['data']['followee_id']).to eq(followee_id)
        end
      end

      response(422, 'already follow/ You can\'t follow your self') do
        let(:params) do
          {
            id: id,
            user: {
              followee_id: followee_id
            }
          }
        end
        before do
          create(:follow, follower_id: follower_id, followee_id: followee_id)
        end
        run_test!
      end
    end
  end

  path '/v1/users/{id}/unfollow' do
    parameter name: 'id', in: :path, type: :integer, description: 'user id'
    parameter name: :params, in: :body, schema: {
      type: :object,
      properties: {
        user: {
          type: :object,
          properties: {
            followee_id: { type: :integer }
          },
          required: %w(followee_id),
        },
      },
      required: %w(user),
    }

    post('unfollow user') do
      consumes "application/json"
      produces "application/json"
      tags "Users"
      let!(:followee_id) { create(:user).id }
      let!(:follower_id) { create(:user).id }
      let(:id) { follower_id }
      response(200, 'successful') do
        let(:params) do
          {
            id: id,
            user: {
              followee_id: followee_id
            }
          }
        end

        before do
          create(:follow, follower_id: follower_id, followee_id: followee_id)
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          expect(JSON.parse(response.body)['data']['status']).to eq('removed')
        end
      end

      response(422, 'No record exist') do
        let(:params) do
          {
            id: id,
            user: {
              followee_id: followee_id
            }
          }
        end
        run_test!
      end
    end
  end

  path '/v1/users/{id}/followee_records' do
    parameter name: 'id', in: :path, type: :integer, description: 'user id'

    get('followee_records user') do
      consumes "application/json"
      produces "application/json"
      tags "Users"
      let!(:followee_id) { create(:user).id }
      let!(:follower_id) { create(:user).id }
      let(:id) { follower_id }
      response(200, 'successful') do
        before do
          create(:follow, followee_id: followee_id, follower_id: follower_id)
          create_list(:alarm, 2, user_id: followee_id)
          create(:alarm, :yesterday_alarm, user_id: followee_id)
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          expect(JSON.parse(response.body)['data']['items'].size).to eq(3)
        end
      end
    end
  end
end
