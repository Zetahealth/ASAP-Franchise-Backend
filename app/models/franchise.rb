class Franchise < ApplicationRecord
    # enum status: { active: 0, inactive: 1, pending: 2 }
    # after_commit :send_welcome_email, on: :create
    belongs_to :user
    has_many :favorites, dependent: :destroy
    has_one :franchise_detail, dependent: :destroy
    has_many :franchise_reviews
    has_many :videos
    accepts_nested_attributes_for :franchise_detail
    # has_many_attached :images
    # has_one :banner
    # has_one :logo

    has_many_attached :images
    has_one_attached :banner   # ✅ ActiveStorage one-to-one
    has_one_attached :logo 
    # has_many :staff
    has_many :staffs, dependent: :destroy
    # after_create :assign_franchises_id 

    private 

    # def assign_franchises_id
    #     self.update_column(:franchise_id, self.id)
    # end


end
