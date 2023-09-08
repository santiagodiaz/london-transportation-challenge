require_relative '../../app/models/station'
require_relative '../../app/models/trip'
require_relative '../../app/services/fare_service'

describe FareService do
  let(:start_station) { Station.new('Holborn', [1]) }
  let(:end_station)   { Station.new('Earl’s Court', [1, 2]) }
  let(:type)          { 'Tube' }
  let(:trip)          { Trip.new(start_station, type) }

  describe '#initial_max_fare' do
    subject { FareService.initial_max_fare(trip) }

    context 'when trip is a tube trip' do
      it 'returns initial fare as THREE_ZONES fare' do
        expect(subject).to eq(FareService::THREE_ZONES)
      end
    end

    context 'when trip is a bus trip' do
      let(:type) { 'Bus' }

      it 'returns initial fare as BUS_JOURNEY' do
        expect(subject).to eq(FareService::BUS_JOURNEY)
      end
    end
  end

  describe '#calculate_fare' do
    subject { FareService.calculate_fare(start_station.zones, end_station.zones) }

    context 'when trip is anywhere in zone 1' do
      it 'returns ANYWHERE_IN_ZONE_1 fare' do
        expect(subject).to eq(FareService::ANYWHERE_IN_ZONE_1)
      end
    end

    context 'when trip is a 1-zone trip excluding Zone 1' do
      let(:start_station) { Station.new('Chelsea', [2]) }
      let(:end_station)   { Station.new('Earl’s Court', [2]) }

      it 'returns ONE_ZONE_EXCLUDING_ZONE_1 fare' do
        expect(subject).to eq(FareService::ONE_ZONE_EXCLUDING_ZONE_1)
      end
    end

    context 'when trip is a 2-zone trip including Zone 1' do
      let(:start_station) { Station.new('Holborn', [1]) }
      let(:end_station)   { Station.new('Wimbledon', [2]) }

      it 'returns TWO_ZONES_INCLUDING_ZONE_1 fare' do
        expect(subject).to eq(FareService::TWO_ZONES_INCLUDING_ZONE_1)
      end
    end

    context 'when trip is a 2-zone trip including Zone 1 and start station contains more than 1 zone' do
      let(:start_station) { Station.new('Earl’s Court', [2, 3]) }
      let(:end_station) { Station.new('Holborn', [1]) }

      it 'returns TWO_ZONES_INCLUDING_ZONE_1 fare' do
        expect(subject).to eq(FareService::TWO_ZONES_INCLUDING_ZONE_1)
      end
    end

    context 'when trip is a 2-zone trip excluding Zone 1' do
      let(:start_station) { Station.new('Hammersmith', [2]) }
      let(:end_station)   { Station.new('Wimbledon', [3]) }

      it 'returns TWO_ZONES_EXCLUDING_ZONE_1 fare' do
        expect(subject).to eq(FareService::TWO_ZONES_EXCLUDING_ZONE_1)
      end
    end

    context 'when trip is a 2-zone trip excluding Zone 1 and end station contains more than 1 zone' do
      let(:start_station) { Station.new('Wimbledon', [3]) }
      let(:end_station)   { Station.new('Earl’s Court', [1, 2]) }

      it 'returns TWO_ZONES_EXCLUDING_ZONE_1 fare' do
        expect(subject).to eq(FareService::TWO_ZONES_EXCLUDING_ZONE_1)
      end
    end

    context 'when trip is a 3-zone trip' do
      let(:start_station) { Station.new('Hammersmith', [1]) }
      let(:end_station)   { Station.new('Wimbledon', [3]) }

      it 'returns THREE_ZONES fare' do
        expect(subject).to eq(FareService::THREE_ZONES)
      end
    end

    context 'when end station has more than one zone' do
      let(:end_station) { Station.new('Earl’s Court', [1, 2, 3]) }

      it 'is considered as a trip anywhere in zone 1 and returns ANYWHERE_IN_ZONE_1 fare' do
        expect(subject).to eq(FareService::ANYWHERE_IN_ZONE_1)
      end
    end

    context 'when trip is from Zone 3 to Zone 1' do
      let(:start_station) { Station.new('Wimbledon', [3]) }
      let(:end_station)   { Station.new('Holborn', [1]) }

      it 'returns THREE_ZONES fare regardless the order of start and end station' do
        expect(subject).to eq(FareService::THREE_ZONES)
      end
    end
  end
end
