class Api::V1::NewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_news, only: [:show, :update, :destroy]

  # GET /api/v1/news
  def index
    news = News.all
    render json: news
  end

  # GET /api/v1/news/:id
  def show
    render json: @news
  end

  # POST /api/v1/news
  def create
    news = News.new(news_params)

    if news.save
      render json: { message: "News created successfully", news: news }, status: :created
    else
      render json: { errors: news.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /api/v1/news/:id
  def update
    if @news.update(news_params)
      render json: { message: "News updated successfully", news: @news }
    else
      render json: { errors: @news.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/news/:id
  def destroy
    @news.destroy
    render json: { message: "News deleted successfully" }
  end

  

  private

  def set_news
    @news = News.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "News not found" }, status: :not_found
  end

  def news_params
    params.require(:news).permit(:title, :date, :image, paragraphs: [], listItems: [])
  end
end
