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
        it 'charges the maximum fare (3.20) and updates card balance' do
          expect { subject }.to change { card.balance }.from(30.0).to(26.8)
        end
      end

      context 'when the trip is a bus trip' do
        let(:type) { 'Bus' }

        it 'charges the bus fare (1.80) and updates card balance' do
          expect { subject }.to change { card.balance }.from(30.0).to(28.2)
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

    subject { TripService.new.end_trip_at(end_station, trip, card, swipe_out_card:) }

    before do
      trip.fare = 3.20
      card.balance = 26.8
    end

    it 'updates trip end station' do
      expect { subject }.to change { trip.end_station }.from(nil).to(end_station)
    end

    context 'when user decided to swipe out' do
      let(:swipe_out_card) { true }

      it 'calculates trip fare and updates card balance' do
        # Trip fare for this example is 2.50 (Anywhere in Zone 1)
        expect { subject }.to change { card.balance }.from(26.8).to(27.5)
      end
    end

    context 'when user decided to not swipe out' do
      it 'does not calculate trip fare or update card balance' do
        expect { subject }.not_to change { card.balance }
      end
    end

    context 'when trip is a bus trip' do
      let(:type) { 'Bus' }

      subject { TripService.new.end_trip_at(end_station, trip, card) }

      before do
        trip.fare = 1.80
        card.balance = 28.2
      end

      it 'does not calculate trip fare or update card balance' do
        expect { subject }.not_to change { card.balance }
      end
    end
  end
end
