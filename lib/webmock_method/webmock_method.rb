require 'webmock'
require 'meta_methods/meta_methods'

module WebmockMethod
  include MetaMethods

  class << self
    attr_accessor :url
  end

  def webmock_method(method_name, param_names, response_proc, url = nil)
    define_method("#{method_name}_with_webmock_method") do |*args|
      param_names.each_with_index do |param_name, index|
        MetaMethods.define_attribute(self, param_name, args[index])
      end

      yield(self, *args) if block_given?

      begin
        response = response_proc.call(binding)

        request_url = url
        request_url = @url if url.nil?
        request_url = WebmockMethod.url if request_url.nil?

        throw "Url is not defined." unless request_url

        WebMock.stub_request(:any, request_url).to_return(:body => response)

        send("#{method_name}_without_webmock_method", *args)
      rescue Exception => e
        puts e.message
        raise e
      ensure
        WebMock.reset!
      end
    end

    alias_method :"#{method_name}_without_webmock_method", method_name
    alias_method method_name, :"#{method_name}_with_webmock_method"

  end

end
