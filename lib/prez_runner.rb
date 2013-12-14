require 'rack'
require 'erb'
require 'yaml'
require 'socket'

module PrezRunner
  class RootRackResponder
    def initialize(prez_path)
      @prez_path = prez_path
    end

    def call env
      path = @prez_path ? @prez_path : path_from_env(env)
      [200, {"Content-Type" => "text/html"}, [Router.map_controller(env['REQUEST_PATH'], path)]] 
    end

    private

    def path_from_env(env)
      env['REQUEST_PATH'][1..env['REQUEST_PATH'].length]
    end
  end

  class Router
    def self.map_controller(request_path, path)
      if request_path.start_with?('/remote')
        RemoteController.render
      else
        HomeController.render(path)
      end
    end
  end

  class RemoteController
    def self.render
      new.render
    end

    def initialize
      @local_ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
    end      

    def render
      ERB.new(File.read('views/remote_control.html.erb')).result(binding)
    end
  end

  class HomeController
    def self.render(path)
      new(path).render
    end

    def initialize(path)
      @container = MainContainer.new(path)
      @local_ip  = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
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
        unless entry.start_with?('.')
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
    attr_reader :content, :data

    def initialize(path)
      read_yaml(path)
    end

    def render
      ERB.new(File.read("views/_slide/#{@data['layout']}.html.erb")).result(binding)
    end

    private

    def default_data
      @data = {
        'layout' => 'regular',
        'title'  => false
      }.merge(@data)
    end

    def read_yaml(path)
      begin
        @content = File.read(path)
        if @content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
          @data = YAML.load(@content)
          @content = @content.gsub(/---(.|\n)*---/, '')
        end
      rescue SyntaxError => e
        puts "YAML Exception reading #{path}: #{e.message}"
      rescue Exception => e
        puts "Error reading file #{path}: #{e.message}"
      end

      @data ||= {}
      default_data
    end
  end
end