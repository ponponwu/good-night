class V1::UsersController < ApplicationController
  rescue_from StandardError, with: :render_error_message
  before_action :check_followee, :set_follow, only: [:follow, :unfollow]

  # POST /users/:id/follow
  def follow
    raise 'Already Follow!' if @follow
    follow = Follow.create!(follower_id: params[:id], followee_id: user_params[:followee_id])
    render json: { result: true , data: follow }
  end

  # POST /users/:id/unfollow
  def unfollow
    raise ResourceNotFoundError unless @follow
    @follow.update!(status: 'removed')
    render json: { result: true , data: @follow }
  end

  # GET /users/:id/followee_records
  # TODO: using jbuilder
  def followee_records
    @followee_ids = Follow.where(follower_id: params[:id], status: 'active').map(&:followee_id)
    end_time = Time.now
    start_time = end_time - 7.days
  
    @alarms = Alarm
             .includes(:user)
             .where(user_id: @followee_ids, awoke_at: start_time..end_time)
             .order(period_of_sleep: :desc)
             .page(params[:page])
  end

  private

  def set_follow
    @follow = Follow.find_by(follower_id: params[:id], followee_id: user_params[:followee_id], status: 'active')
  end

  def check_followee
    raise "You Can't Follow/Unfollow Yourself!" if user_params[:followee_id] == params[:id]
    raise ResourceNotFoundError if User.find(user_params[:followee_id].to_i).nil?
  end

  def user_params
    @_user_params = params.require(:user).permit(
      :followee_id
    ).to_h
  end

  def render_error_message(ex)
    logger.debug ex.message
    logger.debug ex.backtrace.take(5).join("\n")
    render json: { message: ex.message, result: false }, status: :unprocessable_entity
  end
end
