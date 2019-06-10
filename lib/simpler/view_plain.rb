class ViewPlain < ViewBase
  def render
    @env['Content-Type'] = 'text/plain'
    @env['simpler.template']
  end
end
