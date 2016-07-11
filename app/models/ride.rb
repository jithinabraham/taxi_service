class Ride < ApplicationRecord
  attr_accessor :color

  belongs_to :user
  belongs_to :cab, optional: true

  validates :source_latitude, :destination_latitude, :source_longitude, :destination_longitude, presence: true, numericality: {allow_blank: true}
  validate :is_cab_requestable?, on: :create
  validate :check_cab_availability, on: :create

  after_create :inactivate_cab_status
  before_destroy :activate_cab_status

  scope :active, -> { where(is_canceled: false, is_done: false) }

  def is_cab_requestable?
    errors.add(:user, "Cannot request more than one ride") if self.user && self.user.active_rides.present?
  end

  def check_cab_availability
    if source_latitude && source_longitude
      cab=Cab.find_nearest_cab(source_latitude, source_longitude, color)
      if cab
        self.cab=cab
      else
        errors.add(:cab, "No cabs found,Request canceled")
      end
    end
  end

  def cancel
    if !(is_done?)
      update_attribute(:is_canceled, true)
      activate_cab_status
    end
  end

  def complete
    if !(is_canceled?)
      if update_attributes(is_done: true, duration: total_duration_string, distance: total_distance.round(2), amount: total_amount)
        cab.update_current_location(destination_latitude, destination_longitude)
      end
    end
  end


  def inactivate_cab_status
    cab.update_attribute(:is_available, false) if cab
  end

  def activate_cab_status
    cab.update_attribute(:is_available, true) if cab
  end

  private

  def total_distance
    rad_per_deg = Math::PI/180 # PI / 180
    rkm = 6371 # Earth radius in kilometers
    rm = rkm * 1000 # Radius in meters

    dlat_rad = (destination_latitude-destination_longitude) * rad_per_deg # Delta, converted to rad
    dlon_rad = (destination_longitude-source_longitude) * rad_per_deg

    lat1_rad, lon1_rad = source_latitude*rad_per_deg, source_longitude*rad_per_deg
    lat2_rad, lon2_rad = destination_latitude*rad_per_deg, destination_longitude*rad_per_deg

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    (rm * c)/1000
  end

  def total_amount
    amount_for_time=((total_duration)/60).round(2)*1 #distance*1
    amount_for_distance=total_distance*2
    additional_amount_for_pink_cars=(cab.color=='pink') ? 5 : 0
    (amount_for_time+amount_for_distance+additional_amount_for_pink_cars).round(2)
  end

  def total_duration_string
    Time.at(total_duration.to_i.abs).utc.strftime "%H:%M:%S"
  end

  def total_duration
    Time.now-created_at
  end


end
