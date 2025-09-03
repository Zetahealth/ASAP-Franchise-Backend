class FranchiseMailer < ApplicationMailer

    default from: 'zcorp186@gmail.com'

    # def welcome_email(user, franchise, password)
    #     @user = user
    #     @franchise = franchise
    #     @password = password
    #     mail(to: @user.email, subject: "ASAP Franchise Application - Welcome!")
    # end

    # def welcome_email(user_id, franchise_id, password)
    #     @user = User.find(user_id)
    #     @franchise = Franchise.find(franchise_id)
    #     @password = password

    #     @welocome = Template.find_by(name: "Welcome Email")
    #     mail(to: @user.email, subject: @welocome.subject)
    # end

    def welcome_email(user_id, franchise_id, password)

        @user = User.find(user_id)
        @franchise = Franchise.find(franchise_id)
        @password = password

        template = Template.find_by(name: "Welcome Email")

        replacements = {
        "name"  => @user.try(:name) || @user.email,
        "email" => @user.email,
        "password" => @password,
        }

        @content = replace_placeholders(template.body, replacements)

        mail(
        to: @user.email,
        subject: template.subject || "Welcome to ASAP Franchise"
        )
    end



  private

  def replace_placeholders(content, replacements)
    replacements.each do |key, value|
      content = content.gsub("{{#{key}}}", value.to_s)
    end
    content
  end

end
