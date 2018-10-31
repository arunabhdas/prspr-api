class Property < ApplicationRecord

    def self.latest
        Property.order(:updated_at).last
    end
end
