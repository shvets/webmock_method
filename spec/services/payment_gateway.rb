require 'erb'
require 'xmlsimple'

class PaymentGateway
  attr_reader :url

  def initialize
    @url = 'http://www.paymentgateway.com/api/'
  end

  def purchase amount, credit_card
    body = build_body File.dirname(__FILE__) + "/templates/purchase_request.xml.erb", binding

    response = soap_post "purchase", body

    response_body_to_hash response.body
  end

  private

  def build_body request_file_name, binding
    erb = ERB.new(request_file_name)

    erb.result binding
  end

  def soap_post action, body
    uri = URI.parse(URI.escape(@url))

    headers = {}
    headers["User-Agent"] = "Ruby/#{RUBY_VERSION}"
    headers["SOAPAction"] = action
    headers["Content-Type"] = "text/xml;charset=UTF-8"

    connection = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri, headers)

    request.body = body

    connection.request(request)
  end

  def response_body_to_hash body
    result = XmlSimple.xml_in(body)

    Hash[ result.collect {|k,v| [underscore(k), v] } ]
  end

  def underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
  end
end
