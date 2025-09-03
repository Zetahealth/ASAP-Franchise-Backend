# class Api::V1::ProfileController < ApplicationController
#   before_action :authenticate_user!   # Devise JWT authentication
#   before_action :set_profile

#   # GET /api/v1/profile
#   def show
#     render json: @profile, status: :ok
#   end

#   # PATCH/PUT /api/v1/profile
#   def update
#     if @profile.update(profile_params)
#       render json: @profile, status: :ok
#     else
#       render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
#     end
#   end

#   private

#   def set_profile
#     # Assuming each user has only ONE profile (has_one :profile instead of has_many)
#     @profile = current_user.profiles.first_or_create!(email: current_user.email)
#   end

#   def profile_params
#     params.require(:profile).permit(:first_name, :last_name, :user_name, :country, :phone, :email)
#   end
# end


class Api::V1::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def show
    render json: @profile, status: :ok
  end

  def update
    if @profile.update(profile_params)
      render json: @profile, status: :ok
    else
      render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_profile
      @profile = current_user.profile || current_user.create_profile!(email: current_user.email)
  end
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :user_name, :country, :phone, :email)
  end
end
