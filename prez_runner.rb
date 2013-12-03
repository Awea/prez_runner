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
        new(request_path).render
      end

      def initialize(request_path)
        @reveal = Reveal.new(request_path[1..request_path.length])
      end      

      def render
        ERB.new(File.read('views/index.html.erb')).result(binding)
      end
    end
  end

  class Reveal
    def initialize(folder)
      @folder = folder
    end

    def slides
      @slides ||= get_slides
    end

    private

    def get_slides
      dir    = Dir.new(@folder)
      slides = []
      dir.each do |entry|
        unless ['.','..'].include?(entry)
          path = "#{dir.path}/#{entry}"
          if VerticalContainer.valid?(path)
            slides << VerticalContainer.new(path)
          else
            slides << Slide.new(path)
          end
        end
      end
      slides
    end
  end

  class Slide
    def initialize(path)
      @content = File.read(path)
    end

    def render
      ERB.new(File.read('views/_slide.html.erb')).result(binding)
    end
  end

  class VerticalContainer
    attr_reader :slides

    def self.valid?(path)
      Dir.exist?(path)
    end

    def initialize(path)
      @dir    = Dir.new(path)
      @slides = []

      @dir.each do |entry|
        unless ['.','..'].include?(entry)
          @slides << Slide.new("#{@dir.path}/#{entry}")
        end
      end
    end

    def render
      ERB.new(File.read('views/_vertical_slide.html.erb')).result(binding)
    end
  end
end