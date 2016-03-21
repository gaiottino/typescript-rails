require 'open3'
require 'typescript/rails'

module Typescript::Rails::Compiler
  IMPORT_REGEX = /(?:import|export) {\s*[\w,\s]*} from '(.*)'/

  class << self
    def compile(ts_path, source, context, *options)
      dependencies = dependencies_for(ts_path, source)
      dependencies.each { |dep| context.depend_on(dep) }

      path = File.join(Rails.root.to_s, 'app', 'assets', 'typescripts')
      relative_path = ts_path.gsub(path, '')
      js_path = File.join(Rails.root, 'tmp', 'typescript_rails', relative_path).gsub('.ts', '.js')

      command = "#{File.join(Rails.root, 'node_modules', 'typescript', 'bin', 'tsc')} --target ES5 --module system --moduleResolution node --emitDecoratorMetadata --experimentalDecorators --rootDir #{path} --outFile #{js_path} #{ts_path}"
      Rails.logger.info "Typescript::Rails::Compiler #{command}"
      stdout, stderr, exit_status = Open3.capture3(command)
      if exit_status == 0
        File.open(js_path, 'r').read
      else
        raise stderr + stdout
      end
    end

    def dependencies_for(ts_path, source)
      dirname = File.dirname(ts_path)

      full_dep_paths = []
      dependencies = source.scan(IMPORT_REGEX).flatten.select { |path| path.starts_with?('./') || path.starts_with?('../') }
      dependencies.each do |dep|
        dep_path = File.expand_path("#{dep}.ts", dirname)
        if File.exists?(dep_path)
          full_dep_paths << dep_path

          dep_source = File.open(dep_path).read
          if dep_source =~ IMPORT_REGEX
            full_dep_paths.concat(dependencies_for(dep_path, dep_source))
          end
        end
      end
      full_dep_paths.uniq
    end
  end
end
