class Document < ApplicationRecord
    validates :name, presence: true
    validates :file_key, presence: true
    validates :file_url, presence: true
    validates :uploaded_by, presence: true

    before_create :set_defaults

    private

    def set_defaults
        self.file_type ||= File.extname(name).delete(".").upcase if name.present?
        self.uploaded_at ||= Time.current
    end
end
