require 'erb'

module RenderHelper
  extend self

  def render format, template, binding
    body = File.read(template)

    case format
      when :erb
        ERB.new(body).result binding
      else
        body
    end
  end
end
