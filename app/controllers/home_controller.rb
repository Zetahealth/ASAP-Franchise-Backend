class HomeController < ApplicationController

    skip_before_action :authenticate_user!, only: [:index]
    def index
        render json: { message: "Welcome to the Home Page" }
    end
end
