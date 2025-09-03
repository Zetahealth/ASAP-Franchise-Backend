class Api::V1::VideosController < ApplicationController
    def create
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

    def index
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

    def destroy
        video = Video.find(params[:id])

        # Delete from S3
        s3 = Aws::S3::Resource.new(
        region: ENV["AWS_REGION"] || "ap-south-1",
        access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
        secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
        )

        bucket = s3.bucket(ENV["AWS_BUCKET"] || "asap-webapp")
        obj = bucket.object(video.file_key)
        obj.delete if obj.exists?

        # Delete from DB
        video.destroy

        render json: { message: "Video deleted successfully" }, status: :ok
    end



    private

    def video_params
        params.require(:video).permit(:file_key)
    end
end
