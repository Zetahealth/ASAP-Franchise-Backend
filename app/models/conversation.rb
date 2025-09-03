class Conversation < ApplicationRecord
    # belongs_to :created_by, class_name: "User"
    # has_many :messages, dependent: :destroy
    belongs_to :created_by, class_name: "User", optional: true
    has_many :messages, dependent: :destroy

    # helper: who are the participants?
    def participants
        user_ids = messages.pluck(:sender_id, :receiver_id).flatten.compact.uniq
        User.where(id: user_ids)
    end
end
