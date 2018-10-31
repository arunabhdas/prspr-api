json.data do
    json.array! @properties do |property|
        json.partial! 'v1/properties/property', property: property
    end
end