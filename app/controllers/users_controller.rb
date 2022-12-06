class UsersController < ApplicationController
  before_action :check_followee, :set_follow

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
    @follow.update!(status: 'removed')
    head :ok
  end

  def alarms
    @alarms = Alarm.where(user_id: params[:id])
  end

  def follower_records

  end

  private

  def set_follow
    @follow = Follow.find_by(follower_id: params[:id], followee_id: user_params[:followee_id], status: 'active')
  end

  def check_followee
    raise ResourceNotFoundError if User.find(user_params[:followee_id]).nil?
  end

  def user_params
    params.require(:user).permit(
      :followee_id
    ).to_h
  end
end
