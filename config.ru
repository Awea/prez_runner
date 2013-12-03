require 'rack'
require './prez_runner'

app = Rack::Builder.app do
  use Rack::Static, :urls => ["/assets"]
  run PrezRunner::Layout.new
end

run app