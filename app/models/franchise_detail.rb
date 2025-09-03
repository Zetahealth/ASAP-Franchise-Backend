class FranchiseDetail < ApplicationRecord
    belongs_to :franchise
    has_many_attached :images

    validates :investment, presence: true
    validates :roi, presence: true

    after_initialize do
        self.available ||= []
        self.requirements ||= []
        self.who_we_look_for ||= []
        self.training ||= {}
    end
end
