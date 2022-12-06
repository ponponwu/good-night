
class AlarmsController < ApplicationController
  # GET /users/:user_id/alarms
  def index
      alarms = Alarm.where(user_id: params[:user_id]).order(created_at: :desc)
      #TODO: implement with jbuilder
      render json: { status: 'ok' , data: alarms }
  end



end
