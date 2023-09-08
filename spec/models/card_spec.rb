require_relative '../../app/models/card'

describe Card do
  describe '#initialize' do
    subject { Card.new(balance) }

    context 'when balance is a valid float' do
      let(:balance) { 30.0 }

      it 'initializes with a valid balance' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when balance is a negative float' do
      let(:balance) { -30.0 }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Card balance must be greater than or equal to 0')
      end
    end

    context 'when balance is a string' do
      let(:balance) { '30.0' }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Card balance must be a float')
      end
    end
  end
end
