require_relative '../../app/models/trip'
require_relative '../../app/models/station'

describe Trip do
  describe '#initialize' do
    let(:start_station) { Station.new('Holborn', [1]) }
    let(:end_station) { Station.new('Earl’s Court', [1, 2]) }
    let(:type) { 'Tube' }
    let(:swipe_out_card) { true }

    subject { Trip.new(start_station, end_station, type, swipe_out_card:) }

    context 'when trip params are valid' do
      it 'initializes with a valid balance' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when trip type is invalid' do
      let(:type) { 'Invalid' }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, "Invalid trip type. Type must be 'Tube' or 'Bus'.")
      end
    end

    context 'when swipe_out_card is not a boolean' do
      let(:swipe_out_card) { 'true' }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Invalid value for swipe_out_card. Must be a boolean.')
      end
    end

    context 'when start_station is not an instance of Station' do
      let(:start_station) { 'Holborn' }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Invalid station, it must be an instance of the Station class.')
      end
    end

    context 'when end_station is not an instance of Station' do
      let(:end_station) { 'Earl’s Court' }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Invalid station, it must be an instance of the Station class.')
      end
    end
  end
end
