class UsersController < ApplicationController
  before_action :check_followee, :set_follow, only: [:follow, :unfollow]

  # POST /users/:id/follow
  def follow
    ## TODO: add unique for follower_id, followee_id, status
    ## TODO: add index for follower_id, followee_id, status
    return if @follow
    Follow.create(follower_id: params[:id], followee_id: user_params[:followee_id])
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
    end_time = DateTime.now.in_time_zone('Asia/Taipei')
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
  rescue => ex
    raise ResourceNotFoundError.new(ex)
  end

  def user_params
    params.require(:user).permit(
      :followee_id
    ).to_h
  end
end
