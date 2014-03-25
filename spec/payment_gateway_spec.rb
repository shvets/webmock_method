require 'spec_helper'

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

  def valid_credit_card
    stub(
      :first_name => "John",
      last_name: "Appleseed",
      number: "4242424242424242",
      card_type: "VISA",
      month: 8,
      year: Time.now.year+1,
      verification_value: "000"
    )
  end

  def invalid_credit_card
    invalid_credit_card = valid_credit_card

    invalid_credit_card.stubs(:card_type => "DISCOVER")

    invalid_credit_card
  end

end
