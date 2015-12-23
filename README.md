# TypeScript for Rails

Highly modified from the original [typescript-rails] to get it compiling Angular2 using an external node.

## Requirements

The current version requires that [node.js](http://nodejs.org/) is
installed on the system.

## Installation

Add this line to your application's Gemfile:

    gem 'typescript-rails'

And then execute:

    $ bundle

## Usage

Just add a `.ts` file in your `app/assets/typescripts` directory and include it just like you are used to do.

Configurations:

```
# Its defaults are `--target ES5 --module system --moduleResolution node --experimentalDecorators --emitDecoratorMetadata`.

Typescript::Rails::Compiler.default_options = [ ... ]
```

## Referenced TypeScript dependencies

`typescript-rails` recurses through all [TypeScript-style](https://github.com/teppeis/typescript-spec-md/blob/master/en/ch11.md#1111-source-files-dependencies) referenced files and tells its [`Sprockets::Context`](https://github.com/sstephenson/sprockets/blob/master/lib/sprockets/context.rb) that the TS file being processed [`depend`s`_on`](https://github.com/sstephenson/sprockets#the-depend_on-directive) each file listed as a reference. This activates Sprocket’s cache-invalidation behavior when any of the descendant references of the root TS file is changed.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Maintainers

Daniel Gaiottino <daniel@burtcorp.com>

## Authors

Daniel Gaiottino <daniel@burtcorp.com>


