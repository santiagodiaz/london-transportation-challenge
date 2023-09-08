require_relative '../models/trip'
require_relative '../services/fare_service'

class TripService
  class << self
    def start_trip_at(start_station, type, card)
      trip = Trip.new(start_station, type)
      trip.fare = FareService.initial_max_fare(trip)
      process_start_trip(trip, card)
      trip
    end

    def end_trip_at(end_station, trip, card, swipe_out_card: false)
      trip.end_station = end_station
      process_end_trip(trip, card) if swipe_out_card
    end

    private

    def process_start_trip(trip, card)
      raise "Insufficient card balance to do a trip from #{trip.start_station.name}" unless card.balance >= trip.fare

      card.balance -= trip.fare
    end

    def process_end_trip(trip, card)
      card.balance += FareService::THREE_ZONES
      trip.fare = FareService.calculate_fare(trip.start_station.zones, trip.end_station.zones)
      card.balance -= trip.fare
    end
  end
end
