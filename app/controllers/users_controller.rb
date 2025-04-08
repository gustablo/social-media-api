class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  before_action :set_user, only: %i[ show update followers following ]

  def create
    @user = User.new(user_params)
    if @user.password != @user.password_confirmation
      render json: { error: "Password confirmation doesn't match Password" }, status: :unprocessable_entity
    end

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params.except(:password))
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: User.where("nickname LIKE ?", params[:search] + "%")
  end

  def show
    render json: @user
  end

  def posts
    @user = User.find_by(nickname: params.expect(:user_id))
    render json: @user.posts.order(id: :desc)
  end

  def followers
    users = @user.followers.map do |u|
      u.follower
    end
    render json: users
  end

  def following
    users = @user.following.map do |u|
      u.followed
    end
    render json: users
  end

  private

  def set_user
    @user = User.find_by(nickname: params[:id] || params[:user_id])

    if @user.nil?
      head :not_found
    end
  end

  def user_params
    params.expect(user: [ :email_address, :password, :password_confirmation, :nickname, :profile_picture, :cover_picture ])
  end
end
