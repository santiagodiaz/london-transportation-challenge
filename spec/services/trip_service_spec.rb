require_relative '../../app/services/trip_service'

describe TripService do
  let(:start_station) { Station.new('Holborn', [1]) }
  let(:type)          { 'Tube' }
  let(:card)          { Card.new(30.0) }

  describe '#start_trip_at' do
    subject { TripService.start_trip_at(start_station, type, card) }

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
    let(:swipe_out_card)  { false }

    subject { TripService.end_trip_at(end_station, trip, card, swipe_out_card:) }

    before do
      trip.fare = FareService::THREE_ZONES
      card.balance = card.balance - trip.fare
    end

    it 'updates trip end station' do
      expect { subject }.to change { trip.end_station }.from(nil).to(end_station)
    end

    context 'when user decided to swipe out' do
      let(:swipe_out_card) { true }

      it 'calculates trip fare and updates card balance' do
        # Trip fare for this example is "Anywhere in Zone 1"
        expect { subject }
          .to change { card.balance }.from(30.0 - FareService::THREE_ZONES)
                                     .to(30.0 - FareService::ANYWHERE_IN_ZONE_1)
      end
    end

    context 'when user decided to not swipe out' do
      it 'does not calculate trip fare or update card balance' do
        expect { subject }.not_to change { card.balance }
      end
    end

    context 'when trip is a bus trip' do
      let(:type) { 'Bus' }

      subject { TripService.end_trip_at(end_station, trip, card) }

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
