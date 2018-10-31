class Contact < ApplicationRecord
    belongs_to :owner, :class_name => 'User'
    belongs_to :user
    has_and_belongs_to_many :groups

    def display_name
        return self.id.to_s + '-' 
    end
end
