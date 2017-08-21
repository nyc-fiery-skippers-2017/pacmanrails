class UsersController < ApplicationController
  before_action :user_params, only: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render json: {id: @user.id}
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      @highscore = @user.games.order(score: :desc).limit(1)
      @user_games = @user.games.map do |game|
        { score: game.score,
          duration: game.duration,
          created_at: game.created_at.strftime("%m/%d/%Y"),
          username: @user.username,
          highscore_score: @highscore[0].score,
          highscore_date: @highscore[0].created_at.strftime("%m/%d/%Y") }
      end
      render json: @user_games
    else
      render 404
    end
  end

  def destroy
    session.clear
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

end
