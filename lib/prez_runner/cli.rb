require 'thor'
require 'prez_runner'

module PrezRunner
  class CLI < Thor
    default_task :serve

    desc 'serve', 'Serve a directory through a rack app'
    long_desc <<-LONGDESC
      \x5 cli serve` will serve a directory as a prez.
      \x5 You can optionally specifiy a directoy, default is to current directory.
    LONGDESC
    def serve(prez_path = false)
      app = Rack::Builder.app do
        use Rack::Static, :urls => ["/assets"]
        run PrezRunner::RootRackResponder.new(prez_path)
      end

      Rack::Server.start(
        app: app
      )
    end
  end
end

PrezRunner::CLI.start(ARGV)