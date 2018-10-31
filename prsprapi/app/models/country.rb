class Country < ApplicationRecord
    has_many :addresses

    def display_name
        return self.id.to_s + '-' + self.name
    end
end
