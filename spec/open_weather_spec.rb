# 1. Create service

require 'net/http'

class OpenWeather
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

class OpenWeather
  extend WebmockMethod

  webmock_method :quote, [:location, :units], lambda { |binding|
    RenderHelper.render :json, "#{File.dirname(__FILE__)}/stubs/templates/quote_response.json.erb", binding
  }, /#{WebmockMethod.url}/
end

# 3. Test service mock

describe OpenWeather do
  describe "#quote" do
    it "gets the quote" do
      result = JSON.parse(subject.quote("plainsboro, nj", "imperial"))

      expect(result['sys']['country']).to eq("United States of America")
    end
  end
end

