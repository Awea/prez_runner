module PrezRunner
  class Layout
    def call env
      [200, {"Content-Type" => "text/html"}, [File.new('views/index.html').read]] 
    end
  end
end