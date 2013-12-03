module PrezRunner

  module RackResponder
    class Root
      def call env
        [200, {"Content-Type" => "text/html"}, [PrezRunner::Controller::Home.render(env['REQUEST_PATH'])]] 
      end
    end
  end

  module Controller
    class Home
      def self.render(request_path)
        self.new(request_path).render
      end

      def initialize(request_path)
        @content = File.read(request_path[1..request_path.length])
      end      

      def render
        ERB.new(File.read('views/index.html.erb')).result(binding)
      end
    end
  end
end