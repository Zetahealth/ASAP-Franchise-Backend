class FranchiseReview < ApplicationRecord
  belongs_to :franchise
  validates :user_name, :rating, :date, presence: true
  validates :rating, inclusion: { in: 1..5 }
  validates :status, inclusion: { in: ["Pending", "Approved", "Rejected"] }
  
end
