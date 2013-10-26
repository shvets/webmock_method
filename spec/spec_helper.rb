RSpec.configure do |config|

  config.mock_with :mocha

end

require 'webmock'

# Make sure we don't hit external service: when stub is commented, test should fail
WebMock.disable_net_connect!(allow_localhost: true)
