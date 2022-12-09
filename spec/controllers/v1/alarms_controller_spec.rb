require 'rails_helper'

RSpec.describe V1::AlarmsController, type: :controller do
  let!(:user) { create(:user) }
  let(:params) do
    {
      alarm: {
        user_id: user.id
      },
      format: :json
    }
  end
  
  describe '#GET index' do
    subject do
      get :index, params: params
    end
    before do
      create_list(:alarm, 2, user_id: user.id)
      create(:alarm, :yesterday_alarm, user_id: user.id)
    end
    context 'query with own id' do
      it 'should get correct count' do
        res = subject
        expect(response).to have_http_status(200)
        expect(JSON.parse(res.body)['data']['items'].size).to eq(3)
      end
    end
  end

  describe '#POST clock_in' do
    let(:params) do
      {
        alarm: {
          user_id: user.id,
          slept_at: Time.now
        },
        format: :json
      }
    end
    before do
      create(:alarm, :yesterday_alarm, user_id: user.id)
    end
    subject do
      post :clock_in, params: params
    end
    context 'about to sleep' do
      it 'should create alarm record and return alarm history' do
        res = subject
        expect(response).to have_http_status(200)
        expect(JSON.parse(res.body)['data'].size).to eq(2)
      end
    end
  end

  describe '#POST clock_out' do
    let(:params) do
      {
        alarm: {
          user_id: user.id,
          awoke_at: Time.now
        },
        format: :json
      }
    end
    subject do
      post :clock_out, params: params
    end
    context 'about to wake' do
      context 'with correct previous data, alarm awoke_at be nil' do
        let!(:alarm) { create(:alarm, user_id: user.id, slept_at: Time.now - 8.hour, awoke_at: nil) }
        it 'should update alarm record that slept' do
          res = subject
          expect(response).to have_http_status(200)
          expect(alarm.reload.awoke_at).not_to be_nil
        end
      end

      context 'with incorrect data, none of data to be clock out' do
        let!(:alarm) { create(:alarm, user_id: user.id, slept_at: Time.now - 8.hour, awoke_at: Time.now) }
        it 'should return status 422' do
          res = subject
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe '#PUT update' do
    let!(:alarm) { create(:alarm, user_id: user.id, slept_at: Time.now - 8.hour) }
    let(:slept_at) { Time.new(2022,12,8,1) }
    let(:awoke_at) { Time.new(2022,12,8,9) }
    let(:params) do
      {
        id: alarm.id,
        alarm: {
          slept_at: slept_at,
          awoke_at: awoke_at
        },
        format: :json
      }
    end
    
    subject do
      put :update, params: params
    end

    context 'with valid params' do
      it 'should update record as expect' do
        res = subject
        expect(response).to have_http_status(200)
        alarm = JSON.parse(res.body)['data']
        expect(alarm['slept_at'].to_time.utc.to_s).to eq(slept_at.utc.to_s)
        expect(alarm['awoke_at'].to_time.utc.to_s).to eq(awoke_at.utc.to_s)
      end
    end
  end

end