require_relative '../models/card'
require_relative '../models/station'
require_relative '../models/trip'
require_relative '../services/fare_service'
require_relative '../services/trip_service'

card = Card.new(30.0)

holborn = Station.new('Holborn', [1])
earls_court = Station.new('Earl’s Court', [1, 2])
chelsea = Station.new('Chelsea', [1])
wimbledon = Station.new('Wimbledon', [3])
hammersmith = Station.new('Hammersmith', [2])

# Start a trip with a start station and type
# Then end the trip at the end station, indicating if the card was swiped out or not
# Notes:
# - If the card does not have enough balance to start the trip, then we show an error message
# - If the user does not swipe out at the end station, then we show an informative message

begin
  first_trip = TripService.new.start_trip_at(holborn, 'Tube', card)
  TripService.new.end_trip_at(earls_court, first_trip, card, swipe_out_card: true)

  second_trip = TripService.new.start_trip_at(earls_court, 'Bus', card)
  TripService.new.end_trip_at(chelsea, second_trip, card)

  third_trip = TripService.new.start_trip_at(chelsea, 'Tube', card)
  TripService.new.end_trip_at(wimbledon, third_trip, card, swipe_out_card: true)
rescue RuntimeError => e
  puts e.message
end
