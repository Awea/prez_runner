require 'rack'
require 'erb'

module PrezRunner
  class RootRackResponder
    def initialize(prez_path)
      @prez_path = prez_path
    end

    def call env
      path = @prez_path ? @prez_path : path_from_env(env)
      [200, {"Content-Type" => "text/html"}, [HomeController.render(path)]] 
    end

    private

    def path_from_env(env)
      env['REQUEST_PATH'][1..env['REQUEST_PATH'].length]
    end
  end

  class HomeController
    def self.render(path)
      new(path).render
    end

    def initialize(path)
      @container = MainContainer.new(path)
    end      

    def render
      ERB.new(File.read('views/index.html.erb')).result(binding)
    end
  end

  class MainContainer
    def initialize(path)
      @folder = Folder.new(path)
    end

    def slides
      @slides ||= get_slides
    end

    private

    def get_slides
      slides = []
      @folder.paths(true) do |path, is_dir|
        if is_dir
          slides << VerticalSubContainer.new(path)
        else
          slides << Slide.new(path)
        end
      end
      slides
    end
  end

  class VerticalSubContainer
    def initialize(path)
      @folder = Folder.new(path)
    end

    def render
      ERB.new(File.read('views/_vertical_sub_container.html.erb')).result(binding)
    end

    def slides
      @slides ||= get_slides 
    end

    private

    def get_slides
      slides = []
      @folder.paths do |path|
        slides << Slide.new(path)
      end
      slides
    end
  end

  class Folder
    def initialize(path)
      @dir = Dir.new(path)
    end

    def paths(dir_check = false)
      @dir.each do |entry|
        unless ['.','..'].include?(entry)
          path = get_path(entry)
          yield dir_check ? [path, is_dir?(path)] : path
        end
      end
    end

    private

    def is_dir?(path)
      Dir.exist?(path)
    end

    def get_path(entry)
      "#{@dir.path}/#{entry}"
    end
  end

  class Slide
    def initialize(path)
      @path = path
    end

    def content
      @content ||= get_content
    end

    def render
      ERB.new(File.read('views/_slide.html.erb')).result(binding)
    end

    private

    def get_content
      File.read(@path)
    end
  end
end