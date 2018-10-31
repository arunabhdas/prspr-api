json.data do
    json.user do 
        json.partial! 'v1/properties/property', property: @property
    end
end