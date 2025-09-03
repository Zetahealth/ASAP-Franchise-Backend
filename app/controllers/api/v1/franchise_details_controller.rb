# class Api::V1::FranchiseDetailsController < ApplicationController
#     before_action :set_franchise_detail, only: [:update_images , :delete_image]

#     # PATCH /franchise_details/:id/update_images
#     def update_images
#         if params[:images].present?
#         # Purge old images if you want to replace
#         @franchise_detail.images.purge 

#         # Attach new images
#         params[:images].each do |img|
#             @franchise_detail.images.attach(img)
#         end
#         end

#         if @franchise_detail.save
#         render json: {
#             message: "Images updated successfully",
#             images: @franchise_detail.images.map { |img| url_for(img) }
#         }, status: :ok
#         else
#         render json: { error: "Failed to update images" }, status: :unprocessable_entity
#         end
#     end


#     # def show
#     #     franchise_detail = FranchiseDetail.find(params[:id])
#     #     render json: franchise_detail.as_json.merge(
#     #         images: franchise_detail.images.map { |img| url_for(img) }
#     #     )
#     # end

#         # GET /franchise_details/:id
#     def show
#         render json: @franchise_detail.as_json.merge(
#         images: @franchise_detail.images.map { |img| url_for(img) }
#         )
#     end


#     def delete_image
#         image = @franchise_detail.images.find_by(id: params[:image_id])

#         if image
#         image.purge
#         render json: { message: "Image deleted successfully" }, status: :ok
#         else
#         render json: { error: "Image not found" }, status: :not_found
#         end
#     end


#     private

#     def set_franchise_detail
#         @franchise_detail = FranchiseDetail.find(params[:id])
#     end
# end
class Api::V1::FranchiseDetailsController < ApplicationController
  before_action :set_franchise_detail, only: [:update_images, :delete_image, :show]

  # PATCH /franchise_details/:id/update_images
  def update_images
    if params[:images].present?
      @franchise_detail.images.purge # Remove old images if replacing
      params[:images].each { |img| @franchise_detail.images.attach(img) }
    end

    if @franchise_detail.save
      render json: {
        message: "Images updated successfully",
        images: @franchise_detail.images.map { |img| url_for(img) }
      }, status: :ok
    else
      render json: { error: "Failed to update images" }, status: :unprocessable_entity
    end
  end

  # GET /franchise_details/:id
  def show
    render json: @franchise_detail.as_json.merge(
      images: @franchise_detail.images.map { |img| url_for(img) }
    )
  end

  # DELETE /franchise_details/:id/delete_image/:image_id
  def delete_image
    image = @franchise_detail.images.find_by(id: params[:image_id])

    if image
      image.purge
      render json: { message: "Image deleted successfully" }, status: :ok
    else
      render json: { error: "Image not found" }, status: :not_found
    end
  end

  private

  def set_franchise_detail
    @franchise = Franchise.find(params[:id])
    # @franchise_detail = @franchise.franchise_detail
    @franchise_detail = @franchise
    # @franchise_detail = FranchiseDetail.find(params[:id])
  end
end
