class Api::V1::FranchiseReviewsController < ApplicationController
    before_action :set_franchise, only: [:create]

    # GET /api/v1/franchise_reviews
    def index
        reviews = FranchiseReview.all.order(created_at: :desc)
        render json: reviews, status: :ok
    end

    # POST /api/v1/franchise_reviews
    def create
        review = @franchise.franchise_reviews.new(review_params)
        if review.save
        render json: review, status: :created
        else
        render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /api/v1/franchise_reviews/:id
    def update
        review = FranchiseReview.find(params[:id])
        if review.update(review_params)
        render json: review, status: :ok
        else
        render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        review = FranchiseReview.find(params[:id])
        if review.destroy
            render json: { message: "Review deleted successfully" }, status: :ok
        else
            render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
        end
    end


    private

    def set_franchise
        @franchise = Franchise.find(review_params[:franchise_id])
    end

    def review_params
        params.require(:franchise_review).permit(:franchise_id, :user_name, :rating, :comment, :date, :status)
    end


end
