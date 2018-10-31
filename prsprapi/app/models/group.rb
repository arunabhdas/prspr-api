class Group < ApplicationRecord
    belongs_to :owner, :class_name => 'User'
    has_and_belongs_to_many :contacts

    def display_name
        return self.id.to_s + '-' + self.name
    end
end
