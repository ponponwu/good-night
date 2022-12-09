
class V1::AlarmsController < ApplicationController
  rescue_from StandardError, with: :render_error_message
  before_action :get_alarms, only: [:index]

  # GET /users/alarms
  def index
  end

  # params: :id, :slept_at, :awoke_at
  def update
    alarm = Alarm.find(params[:id])
    slept_at = alarm_params[:slept_at] || alarm.slept_at
    awoke_at = alarm_params[:awoke_at] || alarm.awoke_at
    alarm.update!(slept_at: slept_at, awoke_at: awoke_at)
    render json: { result: true , data: alarm }
  end

  def clock_in
    slept_at = alarm_params[:slept_at] || Time.now
    alarm = Alarm.new(user_id: alarm_params[:user_id], slept_at: slept_at)
    if alarm.save
      render json: { result: true , data: get_alarms }
    else
      Rails.logger.error alarm.errors.full_messages
      render json: alarm.errors, status: :unprocessable_entity
    end
  end

  def clock_out
    awoke_at = alarm_params[:awoke_at] || Time.now
    alarm = Alarm.where(user_id: alarm_params[:user_id]).last
    if alarm.awoke_at.nil?
      alarm.update!(awoke_at: awoke_at)
      render json: { result: true , data: get_alarms }
    else
      Rails.logger.error 'You already awoke!'
      render json: { result: false }, status: :unprocessable_entity
    end
  end

  private

  def get_alarms
    @user_id = alarm_params[:user_id]
    @alarms = Alarm.includes(:user).where(user_id: @user_id).order(created_at: :desc).page(params[:page]).to_a
  end

  def alarm_params
    @_alarm_params = params.require(:alarm).permit(
      :user_id,
      :slept_at,
      :awoke_at
    ).to_h
  end

  def render_error_message(ex)
    logger.debug ex.message
    logger.debug ex.backtrace.take(5).join("\n")
    render json: { message: ex.message, result: false }, status: :unprocessable_entity
  end
end