class Notification < ApplicationRecord
    validates :title, presence: true
    validates :message, presence: true
    validates :scheduled_at, presence: true
end
