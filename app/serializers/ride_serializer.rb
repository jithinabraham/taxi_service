class RideSerializer < ActiveModel::Serializer
  attributes :id,:source_latitude,:source_longitude,:destination_latitude,:destination_longitude,:distance,:duration,:amount
  belongs_to :cab
  belongs_to :user
end
