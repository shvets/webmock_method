require 'webmock_method'

require "services/payment_gateway.rb"

class PaymentGateway
  extend WebmockMethod

  webmock_method :purchase, [:amount, :credit_card],
                 lambda { |binding|
                   template = "#{File.dirname(__FILE__)}/templates/purchase_response.xml.erb"
                   RenderHelper.render :erb, template, binding
                  } do |parent, amount, credit_card|
    define_attribute(parent, :error, create_error(parent, "Negative amount")) if amount < 0

    if credit_card.card_type == "VISA"
      define_attribute(parent, :success,  true)
    else
      define_attribute(parent, :success,  false)
      define_attribute(parent, :error_message, "Unsupported Credit Card Type")
    end
  end

  def self.create_error parent, reason
    define_attribute(parent, :error, Exception.new(reason))
  end

end
