# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.find_or_create_by!(email: "admin@asap.com") do |user|
    user.password = "Admin@1234"
    user.password_confirmation = "Admin@1234"
    user.role = 0
end

Template.create!(
  name: "Welcome Email",
  subject: "Welcome to ASAP Franchise",
  body: <<~HTML
    <p>Hi {{name}},</p>
    <p>We’re glad you joined us!</p>
    <p>You can now log in with:</p>
    <ol>
      <li>Email: {{email}}</li>
      <li>Password: {{password}}</li>
    </ol>
    <p>Please change your password after logging in.</p>
    <p>Thanks,<br>ASAP Franchise Team</p>
  HTML
)

Template.create!(
  name: "Password Reset OTP",
  subject: "Reset Your ASAP Franchise Password",
  body: <<~HTML
    <p>Hi {{name}},</p><h3>Your OTP for resetting your password is: {{otp}}</h3><h2>This OTP is valid for 10 minutes.</h2>
  HTML
)

Template.create!(
  name: "Franchise Inquiry Response",
  subject: "Thanks for Your Inquiry",
  body: <<~HTML
    <p>Hi {{name}},</p><p>Thank you for your interest. We will contact you soon.</p>
  HTML
)

roles = {
  # 0 => "SuperAdmin",
  1 => "franchise Admin",
  2 => "User",
  3 =>"staff",
  4 => "Admin",
  5 => "Moderator",
}

roles.each do |role_id, name|
  AdminSettingsUserRole.find_or_create_by!(role: role_id) do |r|
    r.name = name
    r.permissions = {}
  end
end
