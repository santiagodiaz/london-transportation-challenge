require_relative '../models/card'
require_relative '../models/station'
require_relative '../models/trip'
require_relative '../services/fare_service'
require_relative '../services/trip_service'

def execute
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
    first_trip = TripService.start_trip_at(holborn, 'Tube', card)
    log_start_output(first_trip, card)
    TripService.end_trip_at(earls_court, first_trip, card, swipe_out_card: true)
    log_end_output(first_trip, card, swipe_out_card: true)

    second_trip = TripService.start_trip_at(earls_court, 'Bus', card)
    log_start_output(second_trip, card)
    TripService.end_trip_at(chelsea, second_trip, card)
    log_end_output(second_trip, card)

    third_trip = TripService.start_trip_at(chelsea, 'Tube', card)
    log_start_output(third_trip, card)
    TripService.end_trip_at(wimbledon, third_trip, card, swipe_out_card: true)
    log_end_output(third_trip, card, swipe_out_card: true)
  rescue RuntimeError => e
    puts e.message
  end
end

def log_start_output(trip, card)
  puts "Starting trip at #{trip.start_station.name}"
  puts "Trip type: #{trip.type}, the card is charged the maximum fare: #{format('%.2f', trip.fare)}"
  puts "New card balance: #{format('%.2f', card.balance)} \n\n"
end

def log_end_output(trip, card, swipe_out_card: false)
  puts "Ending trip from #{trip.start_station.name} to #{trip.end_station.name}"
  puts 'The user decided not to swipe out at the exit station' unless swipe_out_card || trip.type == 'Bus'
  puts "Trip type: #{trip.type}, Trip fare: #{format('%.2f', trip.fare)}"
  puts "Card balance after trip: #{format('%.2f', card.balance)} \n\n\n"
end

execute
