class Api::V1::NotificationsController < ApplicationController
    before_action :set_notification, only: [:show, :update, :destroy, :toggle]

    # GET /api/v1/notifications
    def index
    notifications = Notification.all.order(scheduled_at: :desc)
    render json: notifications
    end

    # GET /api/v1/notifications/:id
    def show
    render json: @notification
    end

    # POST /api/v1/notifications
    def create
    notification = Notification.new(notification_params)
    if notification.save
        render json: notification, status: :created
    else
        render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
    end
    end

    # PUT/PATCH /api/v1/notifications/:id
    def update
    if @notification.update(notification_params)
        render json: @notification
    else
        render json: { errors: @notification.errors.full_messages }, status: :unprocessable_entity
    end
    end

    # DELETE /api/v1/notifications/:id
    def destroy
    @notification.destroy
    head :no_content
    end

    # PATCH /api/v1/notifications/:id/toggle
    def toggle
    @notification.update(enabled: !@notification.enabled)
    render json: @notification
    end

    private

    def set_notification
    @notification = Notification.find(params[:id])
    end

    def notification_params
    params.require(:notification).permit(:title, :message, :scheduled_at, :enabled)
    end
end
 
