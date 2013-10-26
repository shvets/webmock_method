# 1. Create service

require 'net/http'

class OpenWeatherMapService
  attr_reader :url

  def initialize
    @url = 'http://api.openweathermap.org/data/2.5/weather'
  end

  def quote location, units
    quote_url = "#{url}?q=#{location}%20nj&units=#{units}"

    uri = URI.parse(URI.escape(quote_url))

    Net::HTTP.get(uri)
  end
end

# 2. Create service mock

require 'webmock_method'
require 'json'

class OpenWeatherMapService
  extend WebmockMethod

  webmock_method :quote, [:location, :units], lambda { |_|
    File.open "#{File.dirname(__FILE__)}/stubs/templates/quote_response.json.erb"
  }, /#{WebmockMethod.url}/
end

# 3. Test service mock

# Make sure we don't hit external service: when stub is commented, test should fail
WebMock.disable_net_connect!(allow_localhost: true)

describe OpenWeatherMapService do
  describe "#quote" do
    it "gets the quote" do
      result = JSON.parse(subject.quote("plainsboro, nj", "imperial"))

      expect(result['sys']['country']).to eq("United States of America")
    end
  end
end

