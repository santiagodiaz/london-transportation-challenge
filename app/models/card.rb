class Card
  attr_accessor :balance, :ongoing_trip

  def initialize(balance)
    @balance = balance

    validate_card_data
  end

  private

  def validate_card_data
    raise ArgumentError, 'Card balance must be a float' unless balance.is_a?(Float)
    raise ArgumentError, 'Card balance must be greater than or equal to 0' if balance.negative?
  end
end
