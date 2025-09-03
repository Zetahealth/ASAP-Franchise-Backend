class Staff < ApplicationRecord
    belongs_to :franchise
    belongs_to :user  # if staff also logs in as a User

    # serialize :permissions, Hash
    after_initialize :set_default_permissions, if: :new_record?

    private

    def set_default_permissions
        self.permissions ||= {
        "manage_services" => false,
        "set_price" => false,
        "view_reports" => false
        }
    end
end
