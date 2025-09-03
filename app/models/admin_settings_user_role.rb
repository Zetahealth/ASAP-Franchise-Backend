class AdminSettingsUserRole < ApplicationRecord
    validates :name, presence: true
    validates :role, presence: true, uniqueness: true
    after_initialize :set_default_permissions, if: :new_record?

    private

    def set_default_permissions
        self.permissions ||= {}
    end
end
