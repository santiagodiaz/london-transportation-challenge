class Trip
  attr_reader :type, :start_station
  attr_accessor :fare, :end_station

  VALID_TRIP_TYPES = %w[Tube Bus].freeze

  def initialize(start_station, type)
    @start_station = start_station
    @type = type

    validate_trip_data
  end

  private

  def validate_trip_data
    validate_station
    validate_trip_type
  end

  def validate_station
    raise ArgumentError, 'Invalid station, it must be an instance of the Station class.' unless start_station.is_a?(Station)
  end

  def validate_trip_type
    raise ArgumentError, "Invalid trip type. Type must be 'Tube' or 'Bus'." unless VALID_TRIP_TYPES.include?(type)
  end
end
