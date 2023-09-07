class TripService
  def start_trip_at(start_station, type, card)
    if card.ongoing_trip && card.ongoing_trip.type == 'Tube'
      puts 'The user decided not to swipe out at the exit station'
      puts "Card balance: #{format('%.2f', card.balance)} \n\n"
    end

    trip = Trip.new(start_station, type)
    trip.fare = FareService.new.initial_max_fare(trip)
    card.ongoing_trip = trip
    process_start_trip(trip, card)
    trip
  end

  def end_trip_at(end_station, trip, card)
    trip.end_station = end_station
    card.ongoing_trip = nil
    process_end_trip(trip, card) unless trip.type == 'Bus'
  end

  private

  def process_start_trip(trip, card)
    raise "Insufficient card balance to do a trip from #{trip.start_station.name}" unless card.balance >= trip.fare

    card.balance -= trip.fare
  end

  def process_end_trip(trip, card)
    card.balance += FareService::THREE_ZONES
    trip.fare = FareService.new.calculate_fare(trip.start_station.zones, trip.end_station.zones)
    card.balance -= trip.fare
  end
end
