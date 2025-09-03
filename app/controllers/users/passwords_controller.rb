# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  respond_to :json

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      render json: { message: 'Password reset instructions sent.' }
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end



  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      render json: { message: 'Password has been reset successfully.' }
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # Step 1: Request OTP
  def send_otp
    user = User.find_by(email: params[:email])
    if user
      otp = user.generate_reset_password_otp!
      UserMailer.reset_password_otp(user).deliver_later
      render json: { message: "OTP sent to email." }
    else
      render json: { error: "Email not found" }, status: :not_found
    end
  end

  # Step 2: Verify OTP
  def verify_otp
    user = User.find_by(email: params[:email])
    if user&.valid_reset_password_otp?(params[:otp])
      render json: { message: "OTP verified. Proceed to reset password." }
    else
      render json: { error: "Invalid or expired OTP" }, status: :unprocessable_entity
    end
  end

  # Step 3: Reset password
  def reset_password
    user = User.find_by(email: params[:email])
    if user&.valid_reset_password_otp?(params[:otp])
      if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        user.clear_reset_password_otp!
        render json: { message: "Password reset successfully" }
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid or expired OTP" }, status: :unprocessable_entity
    end
  end


  # POST /change_password
  def change_password
    user = current_user

    # Check if current password matches
    if user.valid_password?(params[:current_password])
      if params[:new_password] == params[:confirm_password]
        if user.update(password: params[:new_password], password_confirmation: params[:confirm_password])
          render json: { message: "Password updated successfully." }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "New password and confirm password do not match." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Current password is incorrect." }, status: :unprocessable_entity
    end
  end


end
