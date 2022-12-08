json.data do
  json.result true 
  json.total @alarms.size
  json.cache! cache_key_for_alarms, expires_in: 8.hours do
    json.items @alarms do |alarm|
      json.extract! alarm, :id, :slept_at, :awoke_at, :period_of_sleep
      json.user_name alarm.user.name
    end
  end
end
