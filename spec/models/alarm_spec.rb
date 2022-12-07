require "rails_helper"

class AlarmTest < ActiveSupport::TestCase
  describe '#calculate_period_of_sleep' do

    let(:alarm) { create(:alarm, slept_at: Time.new(2022, 12, 6), awoke_at: nil)}
    context 'with after_save' do
      it 'awoke_at been updated' do
        alarm.update(awoke_at: Time.new(2022, 12, 6, 12, 30))
        expect(alarm.period_of_sleep).not_to be_nil
        expect(alarm.period_of_sleep).to eq 45000
      end
    end
  end
end