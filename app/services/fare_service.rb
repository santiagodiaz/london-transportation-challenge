class FareService
  ANYWHERE_IN_ZONE_1 = 2.50
  ONE_ZONE_EXCLUDING_ZONE_1 = 2.00
  TWO_ZONES_INCLUDING_ZONE_1 = 3.00
  TWO_ZONES_EXCLUDING_ZONE_1 = 2.25
  THREE_ZONES = 3.20
  BUS_JOURNEY = 1.80

  class << self
    def initial_max_fare(trip)
      trip.type == 'Bus' ? BUS_JOURNEY : THREE_ZONES
    end

    def calculate_fare(start_zones, end_zones)
      intersection = start_zones & end_zones
      if intersection.any? # This is a 1-zone fare
        intersection.include?(1) ? ANYWHERE_IN_ZONE_1 : ONE_ZONE_EXCLUDING_ZONE_1
      else
        zones = closest_zones(start_zones, end_zones)
        if consecutive_zones?(zones) # This is a 2-zone fare
          zones.include?(1) ? TWO_ZONES_INCLUDING_ZONE_1 : TWO_ZONES_EXCLUDING_ZONE_1
        else # This is a 3-zone fare
          THREE_ZONES
        end
      end
    end

    private

    def closest_zones(start_zones, end_zones)
      if end_zones.max > start_zones.max
        [end_zones.min, start_zones.max]
      else
        [start_zones.min, end_zones.max]
      end
    end

    def consecutive_zones?(zones)
      sorted_zones = zones.sort
      sorted_zones[0] + 1 == sorted_zones[1]
    end
  end
end
