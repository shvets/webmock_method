require 'erb'
require 'haml'

module RenderHelper
  extend self

  def render format, template, binding
    body = File.read(template)

    case format
      when :erb
        ERB.new(body).result binding
      when :haml
        Haml::Engine.new(body).render binding
      else
        body
    end
  end
end