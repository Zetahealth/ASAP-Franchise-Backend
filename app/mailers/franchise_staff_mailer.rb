class FranchiseStaffMailer < ApplicationMailer
  default from: 'zcorp186@gmail.com'

  def welcome_email(user_id, franchise_id, password)
    @user = User.find(user_id)
    @franchise = Franchise.find(franchise_id)
    @password = password

    mail(
      to: @user.email,
      subject: "Welcome to #{@franchise.name} Staff Portal"
    )
    
  end
end
