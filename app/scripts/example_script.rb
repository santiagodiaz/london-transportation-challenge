require_relative '../models/card'
require_relative '../models/station'
require_relative '../models/trip'
require_relative '../services/fare_service'
require_relative '../services/trip_service'

card = Card.new(3.0)

holborn = Station.new('Holborn', [1])
earls_court = Station.new('Earl’s Court', [1, 2])
chelsea = Station.new('Chelsea', [1])
wimbledon = Station.new('Wimbledon', [3])
hammersmith = Station.new('Hammersmith', [2])

# Create Trips with a start station, end station, type and decision to swipe out or not at exit station
TripService.new.create_trip(holborn, earls_court, 'Tube', card, true)
TripService.new.create_trip(earls_court, chelsea, 'Bus', card, true)
TripService.new.create_trip(chelsea, wimbledon, 'Tube', card, true)
