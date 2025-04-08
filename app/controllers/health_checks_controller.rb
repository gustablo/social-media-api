class HealthChecksController < ApplicationController
  allow_unauthenticated_access
  def health_check
    render json: { alive: true }, status: :ok
  end
end
