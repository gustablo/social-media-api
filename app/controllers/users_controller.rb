class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  before_action :set_post, only: %i[ show ]

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

  def index
    render json: User.where("nickname: ?", User.sanitize_sql_like("%#{params[:search]}%"))
  end

  def show
    render json: @user
  end

  private

  def set_user
    @user = User.find_by(nickname: params.expect(:id))
  end

  def user_params
    params.expect(user: [ :email_address, :password, :password_confirmation, :nickname ])
  end
end
