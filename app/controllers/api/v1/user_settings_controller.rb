class Api::V1::UserSettingsController < ApplicationController
  before_action :set_user, only: [:update, :destroy]

  # POST /api/v1/user_settings
  def create
    user = User.new(user_params)
    if user.save
      render json: { message: "User created successfully", user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # PUT /api/v1/user_settings/:id
  def update
    if @user.update(user_params)
      render json: { message: "User updated successfully", user: @user }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  # DELETE /api/v1/user_settings/:id
  def destroy
    if @user.destroy
      render json: { message: "User deleted successfully" }
    else
      render json: { errors: "Failed to delete user" }, status: :unprocessable_entity
    end
  end

  def change_role
    user = User.find(change_user_params[:user_id].to_i)
    if change_user_params[:prevoius_role_id].to_i == 2 && change_user_params[:new_role].to_i == 1
      franchise = user.franchises.create(email: user.email)
      user.update(role: change_user_params[:new_role], franchise_id: franchise.id)
    elsif change_user_params[:prevoius_role_id].to_i == 1 && change_user_params[:new_role].to_i == 2
      user.franchises.destroy_all
      user.update(role: change_user_params[:new_role], franchise_id: nil)
    else
      user.update(role: change_user_params[:new_role])
    end
    render json: { message: "User Role changed successfully" , user: user}
  end

  def create_admin_role
    role = AdminSettingsUserRole.new(role_params)
    if role.save
      render json: role, status: :created
    else
      render json: { errors: role.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_admin_role
    @role = AdminSettingsUserRole.find(params[:id])
    if @role.update(role_params)
      render json: @role
    else
      render json: { errors: @role.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def fetch_roles
    role = AdminSettingsUserRole.all
    render json: { message: "User roles successfully Fetched" , role: role}
  end


  def create_presigned_url
    s3 = Aws::S3::Resource.new(
      region: "ap-south-1",
      access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
    )

    bucket_name = "asap-webapp" # hardcode or ENV["AWS_BUCKET"]
    obj = s3.bucket(bucket_name).object("uploads/#{SecureRandom.uuid}/#{params[:filename]}")

    url = obj.presigned_url(:put, expires_in: 3600, content_type: params[:content_type])

    render json: { url: url, key: obj.key }
  end


  # def save_video_reference
  #   video = Video.new(video_params)

  #   if video.save
  #     render json: {
  #       id: video.id,
  #       file_key: video.file_key,
  #       file_url: "https://#{ENV['AWS_BUCKET']}.s3.#{ENV['AWS_REGION']}.amazonaws.com/#{video.file_key}"
  #     }, status: :created
  #   else
  #     render json: { errors: video.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  def save_video_reference
    franchise = Franchise.find(params[:franchise_id])
    video = franchise.videos.new(video_params)

    if video.save
      render json: {
        id: video.id,
        franchise_id: video.franchise_id,
        file_key: video.file_key,
        file_url: video.file_url
      }, status: :created
    else
      render json: { errors: video.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def branch_videos
    franchise = Franchise.find(params[:franchise_id])
    videos = franchise.videos

    render json: videos.map { |video|
      {
        id: video.id,
        franchise_id: video.franchise_id,
        file_key: video.file_key,
        file_url: video.file_url
      }
    }
  end



  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    # adjust according to your schema (email, password, role, status, etc.)
    params.require(:user).permit(:name, :email, :password, :role, :status)
  end

  def change_user_params
    params.require(:user).permit(:user_id, :prevoius_role_id, :new_role)
  end

  # def set_role
  #   @role = AdminSettingsUserRole.find(params[:id])
  # end

  def role_params
    params.require(:admin_settings_user_role).permit(:name, :role, permissions: {})
  end

  def video_params
    params.require(:video).permit(:file_key)
  end


end
