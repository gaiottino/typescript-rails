require 'open3'
require 'typescript/rails'

module Typescript::Rails::Compiler
  class << self
    def compile(ts_path, source, context=nil, *options)
      path = File.join(Rails.root.to_s, 'app', 'assets', 'typescripts')
      relative_path = ts_path.gsub(path, '')
      js_path = File.join(Rails.root, 'tmp', 'typescript_rails', relative_path).gsub('.ts', '.js')

      command = "/usr/local/bin/tsc --target ES5 --module system --moduleResolution node --emitDecoratorMetadata --experimentalDecorators --rootDir #{path} --outFile #{js_path} #{ts_path}"
      Rails.logger.info "Typescript::Rails::Compiler #{command}"
      stdout, stderr, exit_status = Open3.capture3(command)
      if exit_status == 0
        File.open(js_path, 'r').read
      else
        raise stderr + stdout
      end
    end
  end
end
