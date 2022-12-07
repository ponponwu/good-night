FactoryBot.define do
  factory :alarm do
    user_id { create(:user).id }
    slept_at { Time.now - 1.hour }
    awoke_at { Time.now }

    trait :last_week_alarm do
      slept_at { 2.weeks.from_now }
      awoke_at { 1.weeks.from_now }
    end

    trait :yesterday_alarm do
      slept_at { 1.days.ago }
      awoke_at { 1.days.ago + 8.hour }
    end
  end
end
