require 'thor'
require 'tool'
require 'prez_runner'

module PrezRunner
  class CLI < Thor
    default_task :serve

    desc 'serve', 'Serve a directory through a rack app'
    long_desc <<-LONGDESC
      \x5 cli serve` will serve a directory as a prez.
      \x5 You can optionally specifiy a directoy, default is to current directory.
    LONGDESC
    method_option :prez_path, type: :string, default: false
    def serve
      prez_path = options[:prez_path]
      host = Tool.ip

      Faye::WebSocket.load_adapter('thin')

      thin = Rack::Handler.get('thin')

      app = Rack::Builder.app do
        use Rack::Static, :urls => ["/assets"]
        use Faye::RackAdapter, :mount => '/faye'
        run PrezRunner::RootRackResponder.new(prez_path)
      end

      thin.run(app, Port: '8080', Host: host)
    end
  end
end

PrezRunner::CLI.start(ARGV)