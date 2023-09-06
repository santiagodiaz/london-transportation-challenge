class TripService
  def create_trip(start_station, end_station, type, card, swipe_out_card)
    trip = Trip.new(start_station, end_station, type, swipe_out_card:)
    trip.fare = FareService.new.calculate_fare(trip)
    process_trip(trip, card)
    log_output(trip, card)
  rescue RuntimeError => e
    puts e.message
  end

  private

  def process_trip(trip, card)
    unless card.balance >= trip.fare
      raise "Insufficient card balance to do a trip from #{trip.start_station.name} to #{trip.end_station.name}"
    end

    card.balance -= trip.fare
  end

  def log_output(trip, card)
    puts "Starting trip from #{trip.start_station.name} to #{trip.end_station.name}"
    puts 'The user decided to not swipe out at exit station' unless trip.swipe_out_card
    puts "Trip type: #{trip.type}, Trip fare: #{trip.fare}"
    puts "Card balance after trip: #{card.balance} \n\n"
  end
end
