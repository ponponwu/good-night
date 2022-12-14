class Alarm < ApplicationRecord
  belongs_to :user
  after_save :calculate_period_of_sleep, if: -> { awoke_at.present? && period_of_sleep.blank? }
  paginates_per 50

  def calculate_period_of_sleep
    period = TimeDifference.between(slept_at, awoke_at).in_seconds.to_i
    self.update!(period_of_sleep: period)
  end
end
