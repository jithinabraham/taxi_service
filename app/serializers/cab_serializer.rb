class CabSerializer < ActiveModel::Serializer
  attributes :id, :name, :color, :latitude, :longitude
end
