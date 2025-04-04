class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: { error: "Try again later." } }

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      token = start_new_session_for user
      render json: { token: token }, status: :created
    else
      render json: { error: "Invalid email address or password." }, status: :unauthorized
    end
  end

  def destroy
    terminate_session
    head :ok
  end
end
