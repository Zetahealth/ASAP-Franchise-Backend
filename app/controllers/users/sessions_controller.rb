# frozen_string_literal: true

# class Users::SessionsController < Devise::SessionsController
#   # before_action :configure_sign_in_params, only: [:create]

#   # GET /resource/sign_in
#   # def new
#   #   super
#   # end

#   # POST /resource/sign_in
#   # def create
#   #   super
#   # end

#   # DELETE /resource/sign_out
#   # def destroy
#   #   super
#   # end

#   # protected

#   # If you have extra params to permit, append them to the sanitizer.
#   # def configure_sign_in_params
#   #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
#   # end

#   respond_to :json
#   # skip_before_action :verify_authenticity_token
#   before_action :skip_session_storage

#   private

#   def respond_with(resource, _opts = {})
#     render json: { message: 'Logged in successfully.', user: resource }, status: :ok
#   end

#   def respond_to_on_destroy
#     head :no_content
#   end

#   def skip_session_storage
#     request.session_options[:skip] = true
#   end
# end


# frozen_string_literal: true

# class Users::SessionsController < Devise::SessionsController
#   respond_to :json
#   before_action :skip_session_storage



#   def respond_to_on_destroy
#     if current_user
#       render json: { message: "Logged out successfully." }, status: :ok
#     else
#       render json: { message: "No active session." }, status: :unauthorized
#     end
#   end


#   private

#   def respond_with(resource, _opts = {})
#     if resource.persisted?
#       token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
#       render json: {
#         message: 'Logged in successfully.',
#         user: resource,
#         token: token
#       }, status: :ok
#     else
#       render json: { error: 'Invalid login credentials' }, status: :unauthorized
#     end
#   end

#   def respond_to_on_destroy
#     head :no_content
#   end

#   def skip_session_storage
#     request.session_options[:skip] = true
#   end
# end
# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  before_action :skip_session_storage

  private

  # def respond_with(resource, _opts = {})
  #   if resource.persisted?
  #     token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
  #     render json: {
  #       message: 'Logged in successfully.',
  #       user: resource,
  #       token: token
  #     }, status: :ok
  #   else
  #     render json: { error: 'Invalid login credentials' }, status: :unauthorized
  #   end
  # end


  def respond_with(resource, _opts = {})
    if resource.persisted?
      token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

      # fetch role details from AdminSettingsUserRole
      role_details = AdminSettingsUserRole.find_by(role: resource.role)

      # fetch franchise (if user belongs to one)
      franchise_details = resource.franchises&.as_json(only: [:id, :name]) 

      # ✅ Build profile data with avatar URL
      profile_data = resource.profile.as_json.merge({
        avatar_url: resource.profile.avatar.attached? ? Rails.application.routes.url_helpers.url_for(resource.profile.avatar) : nil
      })


      render json: {
        message: 'Logged in successfully.',
        user: resource.as_json(only: [:id, :email, :role, :franchise_id]),
        role: resource.role,
        role_details: role_details&.as_json(only: [:name, :role, :permissions]),
        franchise: franchise_details,
        profile: profile_data,
        token: token
      }, status: :ok
    else
      render json: { error: 'Invalid login credentials' }, status: :unauthorized
    end
  end




  def respond_to_on_destroy
    if current_user
      render json: { message: "Logged out successfully." }, status: :ok
    else
      render json: { message: "No active session." }, status: :unauthorized
    end
  end

  def skip_session_storage
    request.session_options[:skip] = true
  end
end
