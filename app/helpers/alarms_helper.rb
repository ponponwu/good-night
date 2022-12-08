module AlarmsHelper
  def cache_key_for_alarms
    latest = Alarm.where(user_id: @user_id).order(updated_at: :desc).first.try(:updated_at)
    "alarms/user:#{@user_id}/alarm_updated:#{latest}"
  end
end