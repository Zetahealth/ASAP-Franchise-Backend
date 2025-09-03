# frozen_string_literal: true

# class Users::RegistrationsController < Devise::RegistrationsController
#   # before_action :configure_sign_up_params, only: [:create]
#   # before_action :configure_account_update_params, only: [:update]

#   respond_to :json
#   # Prevent Devise from trying to use session
#   before_action :skip_session_storage

#   # GET /resource/sign_up
#   # def new
#   #   super
#   # end

#   # POST /resource
#   # def create
#   #   super
#   # end

#   # GET /resource/edit
#   # def edit
#   #   super
#   # end

#   # PUT /resource
#   # def update
#   #   super
#   # end

#   # DELETE /resource
#   # def destroy
#   #   super
#   # end

#   # GET /resource/cancel
#   # Forces the session data which is usually expired after sign
#   # in to be expired now. This is useful if the user wants to
#   # cancel oauth signing in/up in the middle of the process,
#   # removing all OAuth session data.
#   # def cancel
#   #   super
#   # end

#   # protected

#   # If you have extra params to permit, append them to the sanitizer.
#   # def configure_sign_up_params
#   #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
#   # end

#   # If you have extra params to permit, append them to the sanitizer.
#   # def configure_account_update_params
#   #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
#   # end

#   # The path used after sign up.
#   # def after_sign_up_path_for(resource)
#   #   super(resource)
#   # end

#   # The path used after sign up for inactive accounts.
#   # def after_inactive_sign_up_path_for(resource)
#   #   super(resource)
#   # end

#   private

#   def respond_with(resource, _opts = {})
#     if resource.persisted?
#       render json: { message: 'Signed up successfully.', user: resource }, status: :ok
#     else
#       render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
#     end
#   end

#   def skip_session_storage
#     request.session_options[:skip] = true
#   end
# end
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :authenticate_user!, only: [:destroy_account]
  # POST /signup
  # def create
  #   user = User.new(sign_up_params)
  #   # user.role ||= :user
  #   if user.save
  #     # Instead of sign_up(user), call bypass_sign_in with store: false
  #     # or better: return JWT immediately

  #     token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  #     render json: {
  #       message: "Signed up successfully.",
  #       user: user,
  #       token: token
  #     }, status: :created
  #   else
  #     render json: { errors: user.errors.full_messages },
  #            status: :unprocessable_entity
  #   end
  # end

  def create
    user = User.new(sign_up_params)

    if user.save
      # Create profile with additional params
      user.create_profile(profile_params)

      # Issue JWT
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: {
        message: "Signed up successfully.",
        user: user,
        profile: user.profile,
        token: token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages },
            status: :unprocessable_entity
    end
  end


  def createAdminUser
    user = User.new(sign_up_params_admin)
    if user.save
      # Create profile with additional params
      user.create_profile(profile_params_admin)

      # Issue JWT
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: {
        message: "Signed up successfully.",
        user: user,
        profile: user.profile,
        token: token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages },
            status: :unprocessable_entity
    end
  end


  # def create
  #   user = User.new(sign_up_params)
  #   user.role ||= :user   # set default role if not passed

  #   if user.save
  #     token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  #     render json: {
  #       message: "Signed up successfully.",
  #       user: user,
  #       token: token
  #     }, status: :created
  #   else
  #     render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end
  
  def destroy_account
    unless current_user
      return render json: { error: "Not Authorized" }, status: :unauthorized
    end

    reason   = params[:reason]
    comments = params[:comments]

    AccountDeletion.create!(
      user_id: current_user.id,
      user_email: current_user.email,
      reason: reason,
      comments: comments
    )

    current_user.destroy!

    render json: { message: "Your account has been deleted successfully." }, status: :ok
  end


  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def sign_up_params_admin
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :user_name, :country, :phone ,:email)
  end

  def profile_params_admin
    params.require(:user).permit(:user_name, :phone, :email )
  end

end



