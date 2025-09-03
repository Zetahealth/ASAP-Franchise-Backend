class ApplicationController < ActionController::API
  before_action :authenticate_user!

#   private

#   def authenticate_request
#     header = request.headers["Authorization"]
#     header = header.split(" ").last if header.present?  # "Bearer <token>"

#     decoded = JsonWebToken.decode(header)
#     if decoded
#       @current_user = User.find(decoded[:sub])  # sub = user_id from your token
#     else
#       render json: { error: "Unauthorized" }, status: :unauthorized
#     end
#   end
end
