class FareService
  def initial_max_fare(trip)
    trip.type == 'Bus' ? 1.80 : 3.20
  end

  def calculate_fare(start_zones, end_zones)
    intersection = start_zones & end_zones
    if intersection.any? # This is a 1-zone fare
      intersection.include?(1) ? 2.50 : 2.00
    else
      zones = start_zones + end_zones
      if consecutive_zones?(zones) # This is a 2-zone fare
        zones.include?(1) ? 3.00 : 2.25
      else # This is a 3-zone fare
        3.20
      end
    end
  end

  private

  def consecutive_zones?(zones)
    sorted_zones = zones.sort
    expected_zone = sorted_zones.first

    sorted_zones.each do |zone|
      return false if zone != expected_zone

      expected_zone += 1
    end

    true
  end
end
