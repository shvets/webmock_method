module RenderHelper
  extend self

  def render format, template, binding
    body =  File.read(template)

    case format
      when :json
        body
      when :xml
        ERB.new(body).result binding
      else
        throw "Unsupported format: #{format}"
    end
  end
end
