class Favorite < ApplicationRecord

    belongs_to :user
    belongs_to :franchise

    validates :user_id, uniqueness: { scope: :franchise_id, message: "already favorited this franchise" }
    
end
