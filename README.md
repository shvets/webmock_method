# Webmock Method

Gem-extension for webmock gem for creating services with mocked methods.

## Installation

Add this line to your application's Gemfile:

    gem 'webmock_method'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webmock_method

## Usage

[WebMock] [https://github.com/bblimke/webmock] is gem for stubbing HTTP requests. You can use
it in your tests if you don't want to hit actual service while testing other functionality.
For example:

```ruby
require 'webmock'

WebMock.stub_request(:any, "www.example.com").to_return(:body => "some body")

puts Net::HTTP.get("www.example.com", "/") # some body

```

It will stub all http verbs (GET, POST, PUT etc.) thanks to :any parameter.

You also can use webmock for building **stubbed versions** of your services. This approach is especially
useful when services to be called are not ready yet (maybe by another team) and you still
want to start working on your part and finish it on time.

In order to facilitate the creation of **mocked service methods**, you can use **webmock_method** gem.

How to use it?

First, create **actual service wrapper** that works with future API of "not yet developed service". As an example,
we can use publicly available **OpenWeather** web service.

We will implement call to quote weather for given city. You have to provide **location** and **units** parameters:

```ruby
# services/open_service.rb

require 'net/http'

class OpenWeather
  attr_reader :url

  def initialize
    @url = 'http://api.openweathermap.org/data/2.5/weather'
  end

  def quote location, units
    quote_url = "#{url}?q=#{location}%20nj&units=#{units}"

    uri = URI.parse(URI.escape(quote_url))

    Net::HTTP.get(uri) # At this moment, service is not developed yet...
  end
end
```

Then, create stub/mock for your service:

```ruby
# stubs/open_service.rb

require 'webmock_method'
require 'json'

require 'services/open_weather.rb'

class OpenWeather
  extend WebmockMethod

  webmock_method :quote, [:location, :units], lambda { |binding|
      RenderHelper.render :json, "#{File.dirname(__FILE__)}/stubs/templates/quote_response.json.erb", binding
    }, /#{WebmockMethod.url}/
end
```

**webmock_method** requires you to provide the following information:

- method name to be mocked;
- parameters names for the method (same as in original service);
- proc/lambda expression for building the response;
- url to remote service (optional).

You can build responses of arbitrary complexity with your own code or you can use RenderHelper, that comes with this
gem. Currently it supports 2 formats only: **json** and **xml**. Here is example of how to build xml response:

```ruby
  webmock_method :purchase, [:amount, :credit_card], lambda { |binding|
      RenderHelper.render :xml, "#{File.dirname(__FILE__)}/templates/purchase_response.xml.erb", binding
    }
```

**url** parameter is optional. If you don't specify it, it will try to use **url** attribute defined
on your service or you can define **url** parameter for WebmockMethod:

```ruby
WebmockMethod.url = "http://api.openweathermap.org/data/2.5/weather"
```

And finally, create spec for testing your mocked service:

```ruby
require "stubs/open_weather"

describe OpenWeather do
  describe "#quote" do
    it "gets the quote" do
      result = JSON.parse(subject.quote("plainsboro, nj", "imperial"))

      expect(result['sys']['country']).to eq("United States of America")
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
