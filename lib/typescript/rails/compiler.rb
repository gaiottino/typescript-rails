require 'open3'
require 'typescript/rails'

module Typescript::Rails::Compiler
  class << self
    def compile(ts_path, source, context=nil, *options)
      path = File.join(Rails.root.to_s, 'app', 'assets', 'typescripts')
      relative_path = ts_path.gsub(path, '')
      js_path = File.join(Rails.root, 'tmp', 'typescript_rails', relative_path).gsub('.ts', '.js')

      if File.exist?(js_path) && File.mtime(js_path) > File.mtime(ts_path)
        File.open(js_path, 'r').read
      else
        Rails.logger.debug 'Typescript::Rails::Compiler will compile all .ts files.'
        stdout, stderr, exit_status = Open3.capture3('/usr/local/bin/tsc -w')
        if exit_status == 0
          File.open(js_path, 'r').read
        else
          raise stderr + stdout
        end
      end
    end
  end
end
