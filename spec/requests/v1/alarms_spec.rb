require 'swagger_helper'

RSpec.describe 'v1/alarms', type: :request do
  let!(:user) { create(:user) }
  path '/v1/users/alarms' do
    get('list alarms') do
      tags "Alarms"
      parameter name: :params, in: :query, schema: {
        type: :object,
        properties: {
          alarm: {
            type: :object,
            properties: {
              user_id: { type: :integer }
            },
            required: %w(user_id),
          },
        },
        required: [ 'alarm' ],
      }
      let!(:user) { create(:user) }
      before do
        create_list(:alarm, 2, user_id: user.id)
        create(:alarm, :yesterday_alarm, user_id: user.id)
      end
      
      produces 'application/json'
      response(200, 'successful') do
        
        let(:params) { { alarm: { user_id: user.id } } }
        let(:user_id) { user.id }
        
        run_test! do |response|
          expect(JSON.parse(response.body)['data']['items'].size).to eq(3)
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
      end

      response(422, 'params missing') do
        let(:params) { { user_id: user.id } }
        run_test!
      end
    end
  end

  path '/v1/alarms/clock_in' do
    parameter name: :params, in: :body, schema: {
      type: :object,
      properties: {
        alarm: {
          type: :object,
          properties: {
            user_id: { type: :integer },
            slept_at: { type: :string, format: "date-time" }
          },
          required: %w(user_id),
        },
      },
      required: [ 'alarm' ],
    }
    post('clock_in') do
      consumes "application/json"
      produces "application/json"
      tags "Alarms"
      let!(:user) { create(:user) }
      response(200, 'Alarm created and return list of alarm records') do
        before do
          create(:alarm, :yesterday_alarm, user_id: user.id)
        end
        let!(:params) do
          {
            alarm: {
              user_id: user.id,
              slept_at: Time.now
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
        run_test!
      end

      response(422, 'bad request') do
        let!(:params) do
          {
            alarm: {
              user_id: '0000',
              slept_at: Time.now
            }
          }
        end
        run_test!
      end
    end
  end

  path '/v1/alarms/clock_out' do
    parameter name: :params, in: :body, schema: {
      type: :object,
      properties: {
        alarm: {
          type: :object,
          properties: {
            user_id: { type: :integer },
            awoke_at: { type: :string, format: "date-time" }
          },
          required: %w(user_id),
        },
      },
      required: [ 'alarm' ],
    }
    post('clock_out') do
      consumes "application/json"
      produces "application/json"
      tags "Alarms"
      response(200, 'should update alarm record slept and return list of records') do
        before do
          create(:alarm, user_id: user.id, slept_at: Time.now - 8.hour, awoke_at: nil)
        end
        let!(:params) do
          {
            alarm: {
              user_id: user.id,
              awoke_at: Time.now
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
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['data'].last['awoke_at']).not_to be_nil
        end
      end

      response(422, 'already woke up') do
        before do
          create(:alarm, user_id: user.id, slept_at: Time.now - 8.hour, awoke_at: Time.now)
        end
        let!(:params) do
          {
            alarm: {
              user_id: user.id,
              awoke_at: Time.now
            }
          }
        end
        run_test!
      end
    end
  end

  path '/v1/alarms/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'alarm id'
    parameter name: :params, in: :body, schema: {
      type: :object,
      properties: {
        alarm: {
          type: :object,
          properties: {
            user_id: { type: :integer },
            slept_at: { type: :string, format: "date-time" },
            awoke_at: { type: :string, format: "date-time" }
          },
          required: %w(user_id),
        },
      },
      required: [ 'alarm' ],
    }

    put('update alarm') do
      consumes "application/json"
      produces "application/json"
      tags "Alarms"
      response(200, 'successful') do
        let!(:alarm) { create(:alarm, user_id: user.id, slept_at: Time.now - 8.hour, awoke_at: nil) }
        let(:id) { alarm.id }
        let(:awoke_at) { Time.now }
        let!(:params) do
          {
            id: id,
            alarm: {
              user_id: user.id,
              awoke_at: awoke_at
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
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)['data']['awoke_at'].to_time.utc.to_s).to eq(awoke_at.utc.to_s)
        end
      end
    end
  end
end
