class Distance < ApplicationRecord
before_save :geocode_endpoints, :set_range

  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :startpunkt, presence: true, length: { maximum: 140 }
  validates :zielpunkt, presence: true, length: { maximum: 140 }
  validates :verkehrsmittel, presence: true, length: { maximum: 140}
  geocoded_by :startpunkt, :latitude => :latitude, :longitude => :longitude
  geocoded_by :zielpunkt, :latitude => :destination_lat, :longitude => :destination_long
  after_validation :geocode, :if => :startpunkt_changed?
  after_validation :geocode, :if => :zielpunkt_changed?
  validates :gmaprange, presence: true


  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |distance|
        csv << distance.attributes.values_at(*column_names)
      end
    end
  end

end


private


def geocode_endpoints
  if startpunkt_changed?
    geocoded = Geocoder.search(startpunkt).first
    if geocoded
      self.latitude = geocoded.latitude
      self.longitude = geocoded.longitude
    end
  end
  # Repeat for destination

  # Calculate distance between start point and destination
  def set_range
      if startpunkt_changed?
       lat1=latitude
       lon1=longitude
       lat2=destination_lat
       lon2=destination_long
       rad_per_deg = Math::PI/180

       dLat = (lat2-lat1);
       dLon = (lon2-lon1);
       dLat_rad = dLat * rad_per_deg;
       dLong_rad = dLon * rad_per_deg;
       lat1_rad = lat1 * rad_per_deg;
       lat2_rad = lat2 * rad_per_deg;

       a = Math.sin(dLat_rad/2) * Math.sin(dLat_rad/2) +
           Math.cos(lat1_rad) * Math.cos(lat2_rad) *
           Math.sin(dLong_rad/2) * Math.sin(dLong_rad/2);
       c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
       d = 6371 * c;
       self.range = d
      end
  end
end
