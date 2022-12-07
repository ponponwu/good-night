class UsersController < ApplicationController
  rescue_from StandardError, with: :render_error_message
  before_action :check_followee, :set_follow, only: [:follow, :unfollow]

  # POST /users/:id/follow
  def follow
    ## TODO: add index for follower_id, followee_id, status
    raise 'Already Follow!' if @follow
    Follow.create!(follower_id: params[:id], followee_id: user_params[:followee_id])
    head :ok
  end

  # POST /users/:id/unfollow
  def unfollow
    raise ResourceNotFoundError unless @follow
    @follow.update!(status: 'removed')
    head :ok
  end

  # GET /users/:id/follower_records
  # TODO: Add pagination
  def follower_records
    followee_ids = Follow.where(follower_id: params[:id], status: 'active').map(&:followee_id)
    end_time = Time.now
    start_time = end_time - 7.days
  
    alarms = Alarm.where(user_id: followee_ids, awoke_at: start_time..end_time).order(period_of_sleep: :desc)
    render json: { status: 'ok' , data: alarms }
  end

  private

  def set_follow
    @follow = Follow.find_by(follower_id: params[:id], followee_id: user_params[:followee_id], status: 'active')
  end

  def check_followee
    @user = User.find(user_params[:followee_id].to_i)
    raise ResourceNotFoundError if @user.nil?
  end

  def user_params
    params.require(:user).permit(
      :followee_id
    ).to_h
  end

  def render_error_message(ex)
    logger.debug ex.message
    logger.debug ex.backtrace.take(5).join("\n")
    render json: { message: ex.message, result: false }, status: :unprocessable_entity
  end
end
