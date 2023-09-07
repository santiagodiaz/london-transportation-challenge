require_relative '../../app/models/station'

describe Station do
  describe '#initialize' do
    let(:station_name)  { 'Holborn' }
    let(:zones)         { [1, 2] }

    subject { Station.new(station_name, zones) }

    context 'when stations name and zones are valid' do
      it 'initializes with a valid name and zones' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when station name is not a string' do
      let(:station_name) { 1 }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Station name must be a string')
      end
    end

    context 'when station zones is not an array' do
      let(:zones) { 1 }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Station zones must be an array')
      end
    end

    context 'when station zones is not an array of integers' do
      let(:zones) { ['1'] }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Station zones must be an array of integers')
      end
    end
  end
end
