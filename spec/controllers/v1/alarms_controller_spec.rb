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
    
  end

end