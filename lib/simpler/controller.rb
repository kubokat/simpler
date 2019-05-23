require_relative 'view'

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

      @request.env['simpler.type'] ||= :html

      body = send("render_#{@request.env['simpler.type']}")
      @response.write(body)
    end

    def render_plain
      @request.env['simpler.template']
    end

    def render_html
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params']
    end

    def status(status)
      @response.status = status
    end

    def header(key, value)
      @response[key] = value
    end

    def render(template)
      if template.is_a?(Hash) && template.key?(:plain)
        @response['Content-Type'] = 'text/plain'
        @request.env['simpler.template'] = template[:plain]
        @request.env['simpler.type'] = :plain
      else
        @request.env['simpler.template'] = template
        @request.env['simpler.type'] = :html
      end
    end

  end
end
