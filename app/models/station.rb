class Station
  attr_reader :name, :zones

  def initialize(name, zones)
    @name = name
    @zones = zones

    validate_station_data
  end

  def validate_station_data
    raise ArgumentError, 'Station name must be a string' unless name.is_a?(String)
    raise ArgumentError, 'Station zones must be an array' unless zones.is_a?(Array)
    raise ArgumentError, 'Station zones must be an array of integers' unless zones.all? { |zone| zone.is_a?(Integer) }
    raise ArgumentError, 'Station zones must not be empty.' unless zones.any?
  end
end
