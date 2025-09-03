class Api::V1::DocumentsController < ApplicationController
  include Rails.application.routes.url_helpers  # ensures url_for works in API
  
    def create_presigned_url
        unless params[:filename].present? && params[:content_type].present?
            return render json: { error: "filename and content_type are required" }, status: :unprocessable_entity
        end

        s3 = Aws::S3::Resource.new(
            region: ENV["AWS_REGION"] || "ap-south-1",
            access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
            secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
        )

        bucket_name = ENV["AWS_BUCKET"] || "asap-webapp"
        key = "documents/#{SecureRandom.uuid}/#{params[:filename]}"
        obj = s3.bucket(bucket_name).object(key)

        url = obj.presigned_url(:put, expires_in: 3600, content_type: params[:content_type])

        render json: { url: url, key: key }
    end

    def create
        bucket_name = ENV["AWS_BUCKET"] || "asap-webapp"
        region = ENV["AWS_REGION"] || "ap-south-1"

        document = Document.new(
        name: params[:filename],
        file_type: File.extname(params[:filename]).delete(".").upcase,
        uploaded_by: params[:uploaded_by],
        uploaded_at: Time.current,
        file_key: params[:file_key],
        file_url: "https://#{bucket_name}.s3.#{region}.amazonaws.com/#{params[:file_key]}"
        )

        if document.save
        render json: {
            id: document.id,
            name: document.name,
            type: document.file_type,
            uploadedBy: document.uploaded_by,
            date: document.uploaded_at.strftime("%Y-%m-%d"),
            url: document.file_url
        }, status: :created
        else
        render json: { errors: document.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def index
        documents = Document.all
        render json: documents.map { |doc|
        {
            id: doc.id,
            name: doc.name,
            type: doc.file_type,
            uploadedBy: doc.uploaded_by,
            date: doc.uploaded_at.strftime("%Y-%m-%d"),
            url: doc.file_url
        }
        }
    end


    def destroy
        document = Document.find_by(id: params[:id])

        unless document
        return render json: { error: "Document not found" }, status: :not_found
        end

        # Delete from S3
        s3 = Aws::S3::Resource.new(
        region: ENV["AWS_REGION"] || "ap-south-1",
        access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
        secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
        )

        bucket_name = ENV["AWS_BUCKET"] || "asap-webapp"
        obj = s3.bucket(bucket_name).object(document.file_key)

        begin
        obj.delete if document.file_key.present?
        rescue => e
        Rails.logger.error("S3 delete failed: #{e.message}")
        end

        # Delete from DB
        document.destroy

        render json: { message: "Document deleted successfully" }, status: :ok
    end
end
