class UserMailer < ApplicationMailer



    default from: 'zcorp186@gmail.com'
    
    def reset_password_otp(user)
        @user = user
        @otp  = user.reset_password_otp
        template = Template.find_by(name: "Password Reset OTP")

        replacements = {
        "name"  => @user.try(:name) || @user.email,
        "email" => @user.email,
        "otp"   => @otp
        }

        @content = replace_placeholders(template.body, replacements)

        mail(
        to: @user.email,
        subject: template.subject || "Your Password Reset OTP"
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



