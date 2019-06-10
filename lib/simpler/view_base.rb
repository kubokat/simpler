require 'erb'

class ViewBase

  VIEW_BASE_PATH = 'app/views'.freeze

  def initialize(env)
    @env = env
  end

  def render(binding)
    if @env['simpler.response_type'] == :html
      ViewHtml.new(@env).render(binding)
    else
      ViewPlain.new(@env).render
    end
  end

end