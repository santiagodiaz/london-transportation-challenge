require_relative '../../app/models/card'
require_relative '../../app/models/station'
require_relative '../../app/models/trip'
require_relative '../../app/services/fare_service'
require_relative '../../app/services/trip_service'

describe TripService do
  describe '#create_trip' do
    let(:start_station) { Station.new('Holborn', [1]) }
    let(:end_station) { Station.new('Earl’s Court', [1, 2]) }
    let(:type) { 'Tube' }
    let(:card) { Card.new(30.0) }

    subject { TripService.new.create_trip(start_station, end_station, type, card, true) }

    context 'when card has enough balance to do the trip' do
      it 'does not return an error' do
        expect { subject }.not_to raise_error
      end

      it 'updates card balance after trip' do
        expect { subject }.to change { card.balance }.from(30.0).to(27.5)
      end
    end

    context 'when card has not enough balance to do the trip' do
      let(:card) { Card.new(1.0) }

      it 'raises an error' do
        expected_output = "Insufficient card balance to do a trip from #{start_station.name} to #{end_station.name}\n"

        expect { subject }
          .to output(expected_output)
          .to_stdout
      end
    end
  end
end
