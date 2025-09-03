class Message < ApplicationRecord
    belongs_to :conversation
    belongs_to :sender, class_name: 'User', optional: true
    belongs_to :receiver, class_name: 'User', optional: true

    validates :content, presence: true
    validate :guest_details_present_for_contact

  private

  def guest_details_present_for_contact
    if is_contact_query && sender_id.nil?
      errors.add(:name, "can't be blank") if name.blank?
      errors.add(:email, "can't be blank") if email.blank?
    end
  end

end
