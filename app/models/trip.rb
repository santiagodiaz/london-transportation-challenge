class Trip
  attr_reader :type, :start_station, :end_station, :swipe_out_card
  attr_accessor :fare

  VALID_TRIP_TYPES = %w[Tube Bus].freeze

  def initialize(start_station, end_station, type, swipe_out_card: true)
    validate_trip_data(start_station, end_station, type, swipe_out_card)

    @start_station = start_station
    @end_station = end_station
    @type = type
    @swipe_out_card = swipe_out_card
  end

  private

  def validate_trip_data(start_station, end_station, type, swipe_out_card)
    validate_trip_type(type)
    validate_swipe_out_card(swipe_out_card)
    validate_station(start_station)
    validate_station(end_station)
  end

  def validate_trip_type(type)
    raise ArgumentError, "Invalid trip type. Type must be 'Tube' or 'Bus'." unless VALID_TRIP_TYPES.include?(type)
  end

  def validate_swipe_out_card(swipe_out_card)
    unless [true, false].include?(swipe_out_card)
      raise ArgumentError, 'Invalid value for swipe_out_card. Must be a boolean.'
    end
  end

  def validate_station(station)
    raise ArgumentError, 'Invalid station, it must be an instance of the Station class.' unless station.is_a?(Station)
  end
end
