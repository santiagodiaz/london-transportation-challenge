class TripService
  def start_trip_at(start_station, type, card)
    trip = Trip.new(start_station, type)
    trip.fare = FareService.new.initial_max_fare(trip)
    process_start_trip(trip, card)
    log_start_output(trip, card)
    trip
  end

  def end_trip_at(end_station, trip, card, swipe_out_card: false)
    trip.end_station = end_station
    process_end_trip(trip, card) if swipe_out_card
    log_end_output(trip, card, swipe_out_card)
  end

  private

  def process_start_trip(trip, card)
    raise "Insufficient card balance to do a trip from #{trip.start_station.name}" unless card.balance >= trip.fare

    card.balance -= trip.fare
  end

  def process_end_trip(trip, card)
    card.balance += 3.20
    trip.fare = FareService.new.calculate_fare(trip.start_station.zones, trip.end_station.zones)
    card.balance -= trip.fare
  end

  def log_start_output(trip, card)
    puts "Starting trip at #{trip.start_station.name}"
    puts "Trip type: #{trip.type}, the card is charged the maximum fare: #{format('%.2f', trip.fare)}"
    puts "New card balance: #{format('%.2f', card.balance)} \n\n"
  end

  def log_end_output(trip, card, swipe_out_card)
    puts "Ending trip from #{trip.start_station.name} to #{trip.end_station.name}"
    puts 'The user decided not to swipe out at the exit station' unless swipe_out_card || trip.type == 'Bus'
    puts "Trip type: #{trip.type}, Trip fare: #{format('%.2f', trip.fare)}"
    puts "Card balance after trip: #{format('%.2f', card.balance)} \n\n\n"
  end
end
