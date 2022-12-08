module UsersHelper
  def cache_key_for_followee_records
    latest = Alarm.where(user_id: @followee_ids).order(updated_at: :desc).first.try(:updated_at)
    "followee_ids/#{@followee_ids}/alarm_updated:#{latest}"
  end
end