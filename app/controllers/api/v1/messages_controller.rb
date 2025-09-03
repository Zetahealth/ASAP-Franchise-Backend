class Api::V1::MessagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:contact]

    # For logged-in user-to-owner chat
    # def create
    #     message = Message.new(
    #         sender: current_user,
    #         receiver_id: params[:receiver_id],
    #         content: params[:content],
    #         is_contact_query: false,
    #         email: current_user.email
    #     )

    #     if message.save
    #         render json: { status: 'success', message: 'Message sent', data: message }, status: :created
    #     else
    #         render json: { status: 'error', errors: message.errors.full_messages }, status: :unprocessable_entity
    #     end
    # end

    def create
        conversation = Conversation.find(params[:conversation_id])
        message = conversation.messages.build(
        sender: current_user,
        receiver_id: params[:receiver_id],
        content: params[:content]
        )

        if message.save
        render json: { status: 'success', message: message }, status: :created
        else
        render json: { status: 'error', errors: message.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # For contact page (guest or logged-in)
    # def contact
    #     message = Message.new(
    #     content: params[:content],
    #     is_contact_query: true
    #     )

    #     if current_user
    #         message.sender = current_user
    #     end

    #     message.name  = params[:name]
    #     message.email = params[:email]
    #     message.phone = params[:phone]
    #     message.subject = params[:subject]
    #     message.receiver = User.find_by(role: 0)
        
    #     if message.save
    #     render json: { status: 'success', message: 'Contact query submitted', data: message }, status: :created
    #     else
    #     render json: { status: 'error', errors: message.errors.full_messages }, status: :unprocessable_entity
    #     end
    # end

    # For contact page (guest or logged-in)
    def contact
        conversation = Conversation.create!(
            subject: params[:subject] || "Contact Inquiry",
            franchise_name: params[:franchise_name],
            created_by: current_user 
        )

        message = conversation.messages.build(
            content: params[:content],
            is_contact_query: true,
            sender: current_user,
            receiver: User.find_by(role: 0),
            name: params[:name],
            email: params[:email],
            phone: params[:phone],
            subject: params[:subject]
        )

        if message.save
            render json: { status: 'success', message: 'Contact query submitted', data: message }, status: :created
        else
            render json: { status: 'error', errors: message.errors.full_messages }, status: :unprocessable_entity
        end
    end



    # Inbox messages
    def inbox
        messages = Message.where(receiver: current_user)
        render json: messages
    end

    # Sent messages
    def sent
        messages = Message.where(sender: current_user, is_contact_query: false)
        render json: messages
    end

    def destroy
        message = Message.find_by(id: params[:id])

        if message.nil?
            render json: { status: 'error', message: 'Message not found' }, status: :not_found
            return
        end

        # Optional: Ensure only sender or receiver can delete the message
        if message.sender == current_user || message.receiver == current_user
            message.destroy
            render json: { status: 'success', message: 'Message deleted successfully' }
        else
            render json: { status: 'error', message: 'Not authorized to delete this message' }, status: :forbidden
        end
    end


end
