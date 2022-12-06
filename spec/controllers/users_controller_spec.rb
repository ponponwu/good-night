require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:followee_id) { create(:user).id }
  let!(:follower_id) { create(:user).id }
  let(:params) do
    {
      id: follower_id,
      user: {
        followee_id: followee_id
      }
    }
  end
  describe '#follow' do
    subject do
      post :follow, params: params
    end
    context 'with valid params' do
      it 'should create a follow' do
        expect { subject }.to change { Follow.count }.by 1
      end
    end

    context 'with invalid followee' do
      let(:followee_id) { '#$%^&@#$%' }

      it 'should raise ResourceNotFoundError' do
        expect { subject }.to raise_error(ResourceNotFoundError)
      end
    end
  end

  describe '#unfollow' do
    subject do
      post :unfollow, params: params
    end
    let!(:follow) { create(:follow, follower_id: follower_id, followee_id: followee_id) }
    context 'with valid params' do
      it 'should update follow status' do
        subject
        expect(follow.reload.status).to eq('removed')
      end
    end

    context 'with invalid followee' do
      let(:followee_id) { '#$%^&@#$%' }
      it 'should raise ResourceNotFoundError' do
        expect { subject }.to raise_error(ResourceNotFoundError)
      end
    end
  end

  describe '#follower_records' do
    subject do
      get :follower_records, params: params, format: :json
    end
    before do
      create(:follow, followee_id: followee_id, follower_id: follower_id)
      create_list(:alarm, 2, user_id: followee_id)
      create(:alarm, :yesterday_alarm, user_id: followee_id)
    end
    context 'query with follower id' do
      it 'should get correct count' do
        res = subject
        expect(response).to have_http_status(200)
        expect(JSON.parse(res.body)['data'].size).to eq(3)
      end
    end
  end
end