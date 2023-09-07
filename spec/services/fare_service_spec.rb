require_relative '../../app/models/station'
require_relative '../../app/models/trip'
require_relative '../../app/services/fare_service'

describe FareService do
  let(:start_station) { Station.new('Holborn', [1]) }
  let(:end_station)   { Station.new('Earl’s Court', [1, 2]) }
  let(:type)          { 'Tube' }
  let(:trip)          { Trip.new(start_station, type) }

  describe '#initial_max_fare' do
    subject { FareService.new.initial_max_fare(trip) }

    context 'when trip is a tube trip' do
      it 'returns 3.20' do
        expect(subject).to eq(3.20)
      end
    end

    context 'when trip is a bus trip' do
      let(:type) { 'Bus' }

      it 'returns 1.80' do
        expect(subject).to eq(1.80)
      end
    end
  end

  describe '#calculate_fare' do
    subject { FareService.new.calculate_fare(start_station.zones, end_station.zones) }

    context 'when trip is anywhere in zone 1' do
      it 'returns 2.50' do
        expect(subject).to eq(2.50)
      end
    end

    context 'when trip is a 1-zone trip excluding Zone 1' do
      let(:start_station) { Station.new('Chelsea', [2]) }
      let(:end_station)   { Station.new('Earl’s Court', [2]) }

      it 'returns 2.00' do
        expect(subject).to eq(2.00)
      end
    end

    context 'when trip is a 2-zone trip including Zone 1' do
      let(:start_station) { Station.new('Holborn', [1]) }
      let(:end_station)   { Station.new('Wimbledon', [2]) }

      it 'returns 3.00' do
        expect(subject).to eq(3.00)
      end
    end

    context 'when trip is a 2-zone trip excluding Zone 1' do
      let(:start_station) { Station.new('Hammersmith', [2]) }
      let(:end_station)   { Station.new('Wimbledon', [3]) }

      it 'returns 2.25' do
        expect(subject).to eq(2.25)
      end
    end

    context 'when trip is a 3-zone trip' do
      let(:start_station) { Station.new('Hammersmith', [1]) }
      let(:end_station)   { Station.new('Wimbledon', [3]) }

      it 'returns 3.20' do
        expect(subject).to eq(3.20)
      end
    end

    context 'when end station has more than one zone' do
      let(:end_station) { Station.new('Earl’s Court', [1, 2, 3]) }

      it 'is considered as a trip anywhere in zone 1 and returns 2.50' do
        expect(subject).to eq(2.50)
      end
    end

    context 'when trip is from Zone 3 to Zone 1' do
      let(:start_station) { Station.new('Wimbledon', [3]) }
      let(:end_station)   { Station.new('Holborn', [1]) }

      it 'returns 3.20 as a 3-zone trip regardless the order of start and end station' do
        expect(subject).to eq(3.20)
      end
    end
  end
end
