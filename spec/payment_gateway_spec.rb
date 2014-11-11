require "stubs/payment_gateway"

describe PaymentGateway do

  context "#purchase" do
    it "makes purchase with valid credit card" do
      response = subject.purchase 1000, valid_credit_card

      expect(response['success'][0]).to eq('true')
    end

    it "fails purchase with invalid credit card" do
      response = subject.purchase 1000, invalid_credit_card

      expect(response['success'][0]).to eq('false')
      expect(response['error_message'][0]).to eq('Unsupported Credit Card Type')
    end

    it "returns error response if amount is negative" do
      expect{subject.purchase(-1000, valid_credit_card)}.to raise_exception(Exception)
    end
  end

  private

  def credit_card_class
    Struct.new(:first_name, :last_name, :number, :card_type, :month, :year, :verification_value)
  end

  def valid_credit_card
    credit_card_class.new("John", "Appleseed", "4242424242424242", "VISA", 8, Time.now.year+1, "000")
  end

  def invalid_credit_card
    credit_card_class.new
  end

end
