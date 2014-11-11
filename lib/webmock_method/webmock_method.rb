require 'webmock'
require 'meta_methods/core'

module WebmockMethod
  extend self

  class << self
    attr_accessor :url
  end

  def define_attribute object, key, value
    MetaMethods::Core.instance.define_attribute(object, key, value)
  end

  def webmock_method(method_name, param_names, response_proc, url=nil)
    define_method("#{method_name}_with_webmock_method") do |*args|
      param_names.each_with_index do |param_name, index|
        MetaMethods::Core.instance.define_attribute(self, param_name, args[index])
      end

      yield(self, *args) if block_given?

      begin
        request_url = url
        request_url = @url if request_url.nil?
        request_url = self.url if request_url.nil?
        request_url = WebmockMethod.url if request_url.nil?

        throw "Url is not defined." unless request_url

        if defined?(error)
          WebMock.stub_request(:any, request_url).to_raise(error)
        else
          response = response_proc.call(binding)

          #$responses ||= []
          #
          #$responses << response

          WebMock.stub_request(:any, request_url).to_return(:body => response)
        end

        send("#{method_name}_without_webmock_method", *args)
      rescue Exception => e
        raise e
      ensure
        WebMock.reset!

        #$responses.pop
        #
        #previous_response = $responses.last
        #
        #stub_request(:any, StubWebMethod.stubbed_url(ignore_get_params, self.url)).to_return(:body => response) if previous_response
      end
    end

    alias_method :"#{method_name}_without_webmock_method", method_name
    alias_method method_name, :"#{method_name}_with_webmock_method"
  end

end
