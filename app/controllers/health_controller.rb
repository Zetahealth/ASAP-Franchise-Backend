class HealthController < ActionController::API
  def index
    render json: {status: "ok", env: Rails.env}, status: :ok
  end
end
