require_relative 'view_base'
require_relative 'view_plain'
require_relative 'view_html'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response

      @request.env['simpler.response_type'] ||= :html

      body = render_body
      @response.write(body)
    end

    def render_body
      ViewBase.new(@request.env).render(binding)
    end

    def params
      @request.env
    end

    def status(status)
      @response.status = status
    end

    def header(key, value)
      @response[key] = value
    end

    def render(template)
      if template.is_a?(Hash) && template.key?(:plain)
        @request.env['simpler.template'] = template[:plain]
        @request.env['simpler.response_type'] = :plain
      else
        @request.env['simpler.template'] = template
      end
    end

  end
end
