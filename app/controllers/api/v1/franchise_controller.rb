# class Api::V1::FranchiseController < ApplicationController
#     before_action :authenticate_user!
#     before_action :set_franchise, only: [:show, :update, :destroy]

#     def index
#         @franchises = Franchise.all
#         render json: @franchises, include: :franchise_detail
#     end
    
#     def show
#         render json: @franchise, include: :franchise_detail
#     end

#     # def create
        
#     #     @franchise = Franchise.new(franchise_params)
#     #     if @franchise.save
#     #     render json: @franchise, status: :created
#     #     else
#     #     render json: @franchise.errors, status: :unprocessable_entity
#     #     end
#     # end

#     def filter_franchises
#         @franchises = Franchise.all
#         @franchises = @franchises.where("industry LIKE ?", "%#{params[:industry]}%") if params[:industry].present?
#         @franchises = @franchises.where("city LIKE ?", "%#{params[:city]}%") if params[:city].present?
#         @franchises = @franchises.where("investment_level <= ?", params[:investment_level]) if params[:investment_level].present?

#         render json: @franchises
#     end


#     def create
#     ActiveRecord::Base.transaction do
#         email = franchise_params[:email]

#         # Check if user already exists
#         user = User.find_by(email: email)
#         if user
#         render json: { error: "User already exists with this email" }, status: :unprocessable_content
#         return
#         end

#         # Create user
#         generated_password = SecureRandom.hex(8)
#         user = User.create!(
#         email: email,
#         password: generated_password,
#         role: 1
#         )

#         # Create franchise
#         @franchise = Franchise.new(franchise_params)
#         @franchise.user = user

#         if @franchise.save
#         # Enqueue mailer after transaction commits
#         FranchiseMailer.welcome_email(user.id, @franchise.id, generated_password).deliver_later(wait_until: Time.current + 1.second)

#         render json: @franchise, include: :franchise_detail, status: :created
#         else
#         render json: @franchise.errors, status: :unprocessable_content
#         raise ActiveRecord::Rollback
#         end
#     end
#     rescue => e
#     render json: { error: e.message }, status: :unprocessable_content
#     end




#     def update
#         if @franchise.update(franchise_params)
#         render json: @franchise
#         else
#         render json: @franchise.errors, status: :unprocessable_entity
#         end
#     end

#     def destroy
#         if @franchise.destroy
#             render json: { message: "Franchise deleted successfully." }, status: :ok
#         else
#             render json: { error: "Failed to delete franchise." }, status: :unprocessable_entity
#         end
#     end

#     private

#     def set_franchise
#         @franchise = Franchise.find(params[:id])
#     end

#     def franchise_params
#         params.require(:franchise).permit(:name, :location, :owner, :contact, :description ,:email ,:industry ,:investment_level , :city)
#     end

#     def franchise_params
#         params.require(:franchise).permit(
#             :name, :location, :owner, :contact, :description, :email, :industry, :investment_level, :city,
#             franchise_detail_attributes: [
#             :investment, :breakeven, :area, :roi, :locations, :year, :about, :origin, :support,
#             { available: [] },
#             { requirements: [] },
#             { who_we_look_for: [] },
#             training: [:note, { preOpening: [], grandOpening: [] }]
#             ]
#         )
#     end



# end


class Api::V1::FranchiseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_franchise, only: [:show, :update, :destroy , :upload_banner , :upload_logo]

  # def index
  #   @franchises = Franchise.includes(:franchise_detail).all
  #   render json: @franchises, include: :franchise_detail
  # end


  def index
    @franchises = Franchise.includes(:franchise_detail).all

    render json: @franchises.map { |franchise|
      {
        id: franchise.id,
        name: franchise.name,
        franchise_detail: franchise.franchise_detail.present? ? {
          id: franchise.franchise_detail.id,
          location: franchise.location,
          investment: franchise.franchise_detail.investment,
          roi: franchise.franchise_detail.roi,
          roiColor: franchise.franchise_detail.roi.include?('15-20%') ? "bg-green-200 text-green-800" : franchise.franchise_detail.roi.include?('10-15%') ? "bg-yellow-200 text-yellow-800" : "bg-red-200 text-red-800",
          
        } : nil,
        logo: franchise.logo.attached? ? url_for(franchise.logo) : nil,
        banner: franchise.banner.attached? ? url_for(franchise.banner) : nil
      }
    }
  end



  def show
    images = @franchise.images.attached? ? @franchise.images.map { |img| url_for(img) } : []
    logo = @franchise.logo.attached? ? url_for(@franchise.logo) : nil
    banner = @franchise.banner.attached? ? url_for(@franchise.banner) : nil
    render json: {
      franchise: @franchise,
      detailsImages: images,
      logo: logo,
      banner: banner,
      franchise_detail: @franchise.franchise_detail
    }
  end


   # POST /api/v1/franchise/:id/upload_logo
  def upload_logo 
    if params[:logo].present?
      @franchise.logo.attach(params[:logo])
      render json: { message: "Logo uploaded successfully", logo_url: url_for(@franchise.logo) }
    else
      render json: { error: "No logo file provided" }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/franchise/:id/upload_banner
  def upload_banner
    if params[:banner].present?
      @franchise.banner.attach(params[:banner])
      render json: { message: "Banner uploaded successfully", banner_url: url_for(@franchise.banner) }
    else
      render json: { error: "No banner file provided" }, status: :unprocessable_entity
    end
  end




  def filter_franchises
    @franchises = Franchise.all
    @franchises = @franchises.where("industry LIKE ?", "%#{params[:industry]}%") if params[:industry].present?
    @franchises = @franchises.where("city LIKE ?", "%#{params[:city]}%") if params[:city].present?
    @franchises = @franchises.where("investment_level <= ?", params[:investment_level]) if params[:investment_level].present?

    render json: @franchises, include: :franchise_detail
  end

  def create
    ActiveRecord::Base.transaction do
      email = franchise_params[:email]

      user = User.find_by(email: email)
      if user
        render json: { error: "User already exists with this email" }, status: :unprocessable_content
        return
      end

      generated_password = SecureRandom.hex(8)
      user = User.create!(
        email: email,
        password: generated_password,
        role: 1
      )

      @franchise = Franchise.new(franchise_params)
      @franchise.user = user
      
      if @franchise.save
        @franchise.create_franchise_detail(locations: franchise_params[:location])
        user.update(franchise_id: @franchise.id)
        user.create_profile(profile_params)
        # FranchiseMailer.welcome_email(user.id, @franchise.id, generated_password).deliver_later(wait_until: Time.current + 1.second)
        render json: @franchise, include: :franchise_detail, status: :created
      else
        render json: @franchise.errors, status: :unprocessable_content
        raise ActiveRecord::Rollback
      end
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_content
  end

  def update
    if @franchise.update(franchise_params)
      render json: @franchise, include: :franchise_detail
    else
      render json: @franchise.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @franchise.destroy
      render json: { message: "Franchise deleted successfully." }, status: :ok
    else
      render json: { error: "Failed to delete franchise." }, status: :unprocessable_entity
    end
  end


  private

  def set_franchise
    @franchise = Franchise.find(params[:id])
  end

  def franchise_params
    params.require(:franchise).permit(
      :name, :location, :owner, :contact, :description, :email, :industry, :investment_level, :city,
      franchise_detail_attributes: [
        :investment, :breakeven, :area, :roi, :locations, :year, :about, :origin, :support,
        { available: [] },
        { requirements: [] },
        { who_we_look_for: [] },
        { training: [:note, { preOpening: [], grandOpening: [] }] }
      ]
    )
  end
  def profile_params
    params.require(:franchise).permit(:email)
  end
end
