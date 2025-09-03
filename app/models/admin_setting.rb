class AdminSetting < ApplicationRecord
    belongs_to :user 
    after_initialize :set_default_permissions, if: :new_record?

    private

    def set_default_permissions
        self.permissions ||= {}
    end
end
