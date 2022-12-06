FactoryBot.define do
  factory :alarm do
    user_id { create(:user).id }
    slept_at { DateTime.now - 1.hour }
    awoke_at { DateTime.now }

    trait :last_week_alarm do
      slept_at { 2.weeks.from_now }
      awoke_at { 1.weeks.from_now }
    end
  end
end
