class Card
  attr_accessor :balance

  def initialize(balance)
    validate_card_data(balance)

    @balance = balance
  end

  private

  def validate_card_data(balance)
    raise ArgumentError, 'Card balance must be a float' unless balance.is_a?(Float)
    raise ArgumentError, 'Card balance must be greater than or equal to 0' if balance.negative?
  end
end
