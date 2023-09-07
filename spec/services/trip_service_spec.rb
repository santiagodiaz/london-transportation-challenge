require_relative '../../app/models/card'
require_relative '../../app/models/station'
require_relative '../../app/models/trip'
require_relative '../../app/services/fare_service'
require_relative '../../app/services/trip_service'

describe TripService do
  let(:start_station) { Station.new('Holborn', [1]) }
  let(:type)          { 'Tube' }
  let(:card)          { Card.new(30.0) }

  describe '#start_trip_at' do
    subject { TripService.new.start_trip_at(start_station, type, card) }

    context 'when card has enough balance to do the trip' do
      context 'when the trip is a tube trip' do
        it 'charges the maximum fare (THREE_ZONES fare) and updates card balance' do
          expect { subject }
            .to change { card.balance }.from(30.0).to(30.0 - FareService::THREE_ZONES)
        end
      end

      context 'when the trip is a bus trip' do
        let(:type) { 'Bus' }

        it 'charges the bus fare (BUS_JOURNEY fare) and updates card balance' do
          expect { subject }
            .to change { card.balance }.from(30.0).to(30.0 - FareService::BUS_JOURNEY)
        end
      end

      context 'when the card has already started a trip' do
        let(:trip) { Trip.new(start_station, type) }
        let(:expected_balance) { 30.0 - FareService::THREE_ZONES - FareService::THREE_ZONES }

        before do
          card.ongoing_trip = trip
          card.balance = 30.0 - FareService::THREE_ZONES
        end

        it 'charges the maximum fare (THREE_ZONES fare) and updates card balance' do
          expect { subject }
            .to change { card.balance }.from(30.0 - FareService::THREE_ZONES)
                                       .to(expected_balance)
        end

        it 'outputs an informative message' do
          expected_output = "The user decided not to swipe out at the exit station\n" \
                            "Card balance: #{format('%.2f', card.balance)} \n\n"

          expect { subject }
            .to output(expected_output)
            .to_stdout
        end
      end

      it 'returns the trip' do
        expect(subject).to be_a(Trip)
      end
    end

    context 'when card has not enough balance to do the trip' do
      let(:card) { Card.new(1.0) }

      it 'raises an error' do
        expect { subject }
          .to raise_error(RuntimeError, "Insufficient card balance to do a trip from #{start_station.name}")
      end
    end
  end

  describe '#end_trip_at' do
    let(:end_station)     { Station.new('Earl’s Court', [1, 2]) }
    let(:trip)            { Trip.new(start_station, type) }

    subject { TripService.new.end_trip_at(end_station, trip, card) }

    before do
      trip.fare = FareService::THREE_ZONES
      card.balance = card.balance - trip.fare
    end

    it 'updates trip end station' do
      expect { subject }.to change { trip.end_station }.from(nil).to(end_station)
    end

    it 'calculates trip fare and updates card balance' do
      # Trip fare for this example is "Anywhere in Zone 1"
      expect { subject }
        .to change { card.balance }.from(30.0 - FareService::THREE_ZONES)
                                   .to(30.0 - FareService::ANYWHERE_IN_ZONE_1)
    end

    context 'when trip is a bus trip' do
      let(:type) { 'Bus' }

      subject { TripService.new.end_trip_at(end_station, trip, card) }

      before do
        trip.fare = FareService::BUS_JOURNEY
        card.balance = card.balance - trip.fare
      end

      it 'does not calculate trip fare or update card balance' do
        expect { subject }.not_to change { card.balance }
      end
    end
  end
end
