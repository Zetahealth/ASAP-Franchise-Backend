class Video < ApplicationRecord
    belongs_to :franchise

    def file_url
        bucket =ENV["AWS_BUCKET"] || "asap-webapp"
        region =ENV["AWS_REGION"] || "ap-south-1"
        "https://#{bucket}.s3.#{region}.amazonaws.com/#{file_key}"
    end
end
