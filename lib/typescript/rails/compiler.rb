require 'open3'
require 'typescript/rails'

module Typescript::Rails::Compiler
  class << self
    def compile(ts_path, source, context=nil, *options)
      stdout, stderr, exit_status = Open3.capture3('/usr/local/bin/tsc')

      if exit_status == 0
        path = File.join(Rails.root.to_s, 'app', 'assets', 'typescripts')
        relative_path = ts_path.gsub(path, '')
        javascript_file = File.open(File.join(Rails.root, 'tmp', 'typescript_rails', relative_path).gsub('.ts', '.js'))
        javascript_file.read
      else
        raise stderr + stdout
      end
    end
  end
end
