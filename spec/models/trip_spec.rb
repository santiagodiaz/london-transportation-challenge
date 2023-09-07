require_relative '../../app/models/trip'
require_relative '../../app/models/station'

describe Trip do
  describe '#initialize' do
    let(:start_station) { Station.new('Holborn', [1]) }
    let(:type)          { 'Tube' }

    subject { Trip.new(start_station, type) }

    context 'when trip params are valid' do
      it 'initializes with a valid start station and type' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when trip type is invalid' do
      let(:type) { 'Invalid' }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, "Invalid trip type. Type must be 'Tube' or 'Bus'.")
      end
    end

    context 'when start_station is not an instance of Station' do
      let(:start_station) { 'Holborn' }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Invalid station, it must be an instance of the Station class.')
      end
    end
  end
end
