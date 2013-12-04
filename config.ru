require 'rack'
require 'erb'
require './lib/prez_runner'

app = Rack::Builder.app do
  use Rack::Static, :urls => ["/assets"]
  run PrezRunner::RackResponder::Root.new
end

run app