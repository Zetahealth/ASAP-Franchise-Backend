class Api::V1::ConversationsController < ApplicationController
  #   def index
  #   conversations = Conversation.includes(:messages).all
  #   render json: conversations.to_json(include: { messages: { only: [:id, :content, :sender_id, :receiver_id, :created_at] } })
  # end

  # GET /api/v1/conversations
  def index
    conversations = Conversation
      .joins(:messages)
      .where("messages.sender_id = :id OR messages.receiver_id = :id", id: current_user.id)
      .distinct

    render json: conversations.to_json(include: {
      messages: {
        only: [:id, :content, :sender_id, :receiver_id, :created_at]
      }
    })
  end

  # def show
  #   conversation = Conversation.includes(:messages).find(params[:id])
  #   render json: conversation.to_json(include: :messages)
  # end

  def show
    conversation = Conversation.includes(:messages).find(params[:id])
    render json: conversation.to_json(include: {
      messages: { only: [:id, :content, :sender_id, :receiver_id, :created_at], order: "created_at ASC" }
    })
  end


  def create
    conversation = Conversation.new(
      subject: params[:subject],
      franchise_name: params[:franchise],
      created_by: current_user
    )
    if conversation.save
      render json: { status: 'success', conversation: conversation }, status: :created
    else
      render json: { status: 'error', errors: conversation.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
