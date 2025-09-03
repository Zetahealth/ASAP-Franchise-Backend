class Api::V1::FavoriteController < ApplicationController
  before_action :set_franchise, only: [:create , :destroy]

  # GET /api/v1/favorites
  def index
    favorites = current_user.favorites
    render json: favorites, status: :ok
  end

  # POST /api/v1/favorites
  def create
    favorite = current_user.favorites.new(franchise: @franchise)

    if favorite.save
      render json: { message: "Franchise added to favorites" }, status: :created
    else
      render json: { errors: favorite.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/favorites/:id
  def destroy
    favorite = current_user.favorites.find_by(franchise: @favorite)
    if favorite
      favorite.destroy
      render json: { message: "Franchise removed from favorites" }, status: :ok
    else
      render json: { error: "Favorite not found" }, status: :not_found
    end
  end

  private

  def set_franchise
    @franchise = Franchise.find(params[:franchise_id]) if params[:franchise_id].present?
    @favorite = Franchise.find(params[:id]) if params[:id].present?
  end
end
