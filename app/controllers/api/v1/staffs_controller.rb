class Api::V1::StaffsController < ApplicationController
  before_action :set_franchise

    def create_staff
        email = franchise_params[:email]
        franchise_id = franchise_params[:franchise_id]

        # 1. Check if user already exists
        user = User.find_by(email: email)
        if user
            render json: { error: "User already exists with this email" }, status: :unprocessable_entity
            return
        end

        # 2. Create user
        generated_password = SecureRandom.hex(8)
        user = User.create!(
            email: email,
            password: generated_password,
            role: 3, # staff role
            franchise_id: franchise_id
        )
        user.create_profile(profile_params)
        # 3. Create staff record and assign user to franchise
        staff = @franchise.staffs.new(user_id: user.id, franchise_id: @franchise.id)

        if staff.save
            # 4. Send welcome email
            FranchiseStaffMailer.welcome_email(user.id, user.franchise_id, generated_password).deliver_later(wait_until: Time.current + 1.second)

            render json: { message: "Staff user created successfully", user: user, staff: staff }, status: :created
        else
            render json: { errors: staff.errors.full_messages }, status: :unprocessable_entity
        end
    end


    def update_permissions
        staff = @franchise.staffs.find_by(user_id: params[:id])
        return render json: { error: "Staff not found for this franchise" }, status: :not_found unless staff

        if staff.update(permissions: params[:permissions])
            render json: staff
        else
            render json: { errors: staff.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        staff = @franchise.staffs.find_by(user_id: params[:id])
        return render json: { error: "Staff not found for this franchise" }, status: :not_found unless staff
        user = staff.user
        ActiveRecord::Base.transaction do
            staff.destroy!
            user.destroy! if user.present?
        end
        render json: { message: "Staff deleted successfully" }, status: :ok
        rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
    end

    

    private

    def set_franchise
        @franchise = Franchise.find(params[:franchise_id])
    end

    def franchise_params
        params.require(:staff).permit(:email, :franchise_id)
    end

    def profile_params
        params.require(:staff).permit(:email)
    end

  
end
