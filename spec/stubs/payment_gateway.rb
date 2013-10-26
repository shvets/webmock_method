require 'webmock_method'

require "services/payment_gateway.rb"

class PaymentGateway
  extend WebmockMethod

  webmock_method :purchase, [:amount, :credit_card], lambda { |binding|
    RenderHelper.render :erb, "#{File.dirname(__FILE__)}/templates/purchase_response.xml.erb", binding
    } do |parent, _, credit_card|
    if credit_card.card_type == "VISA"
      define_attribute(parent, :success,  true)
    else
      define_attribute(parent, :success,  false)
      define_attribute(parent, :error_message, "Unsupported Credit Card Type")
    end
  end

end
