class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create

  end

  def show
    status 201
    render plain: "Plain text response params id: #{params['simpler.params']['id']}"
  end

end
