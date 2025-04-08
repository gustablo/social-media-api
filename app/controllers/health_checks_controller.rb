class HealthChecksController < ApplicationController
  def health_check
    render json: { alive: true }, status: :ok
  end
end
