class Cab < ApplicationRecord
  validates :name, presence: true
  validates :latitude, numericality: true, on: :update
  validates :longitude, numericality: true, on: :update

  scope :active, -> { where(is_deleted: false, is_available: true) }

  def update_current_location(latitude, longitude)
    if latitude && longitude
      update_attributes(latitude: latitude, longitude: longitude, is_available: true)
    else
      errors.add(:latitude, 'cant be blank') unless latitude
      errors.add(:longitude, 'cant be blank') unless longitude
      false
    end
  end

  def self.find_nearest_cab(source_latitude, source_longitude, color)
    # Pythagorean theorem for distance calculation sqrt((x2-x1)^2 + (Y2-Y1)^2)
    if source_latitude and source_longitude
      if !color.present?
        Cab.active.select("cabs.*,sqrt(POWER(latitude-#{source_latitude},2)+POWER(longitude-#{source_longitude},2)) as distance").order('distance ASC').first
      else
        Cab.active.select("cabs.*,sqrt(POWER(latitude-#{source_latitude},2)+POWER(longitude-#{source_longitude},2)) as distance").where(color: color).order('distance ASC').first
      end
    end
  end

end
