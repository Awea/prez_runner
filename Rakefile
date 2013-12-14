require 'rubygems'
require 'rake'

namespace :sources do
  task :build do
    sh "go build -o bin/remote_control sources/remote_control/conn.go sources/remote_control/hub.go sources/remote_control/main.go"
  end
end