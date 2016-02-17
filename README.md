# tilt

Tilt Is Loader of Template. It is generalized template engine interface.

[![Build Status](https://travis-ci.org/MakeNowJust/tilt.svg?branch=master)](https://travis-ci.org/MakeNowJust/tilt)
[![Dependency Status](https://shards.rocks/badge/github/MakeNowJust/tilt/status.svg)](https://shards.rocks/github/MakeNowJust/tilt)
[![devDependency Status](https://shards.rocks/badge/github/MakeNowJust/tilt/dev_status.svg)](https://shards.rocks/github/MakeNowJust/tilt)


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  tilt:
    github: MakeNowJust/tilt
```


## Supported engines

  - [ecr](http://crystal-lang.org/api/ECR.html) - Embedded Crystal
  - [crustache](https://github.com/MakeNowJust/crustache) - {{[Mustache](https://mustache.github.io/)}} for Crystal
  - [slang](https://github.com/jeromegn/slang) - Slim-inspired templating language for Crystal

## Usage

### For users

```crystal
require "tilt"

# Load template engines which are used in your app
require "ecr/macros"
require "crustache" # MakeNowJust/crustache
require "slang"     # jeromegn/slang


# Render some templates

puts Tilt.render "hello.ecr"      # render as "ecr"
puts Tilt.render "hello.mustache" # render as "mustache" (using crustache)
puts Tilt.render "hello.slang"    # render as "slang"


# Set the default template engine

Tilt.default_engine "ecr"

puts Tilt.render "hello" # render as "ecr" although without extension


# Other APIs

# It is like `Tilt.render`, but it requires IO object then renders to this.
puts String.build { |io| Tilt.embed "hello", io }


# Load specified template file, and define `#to_s` method to render this file.
class HelloView
  def initialize(@name); end

  getter name

  Tilt.file "hello"
end

puts HelloView.new("Tilt").to_s


# Passing additional arguments to the template if the engine supported
puts Tilt.render("hello.mustache", { "name" => "Tilt" })


# Add your template engine
Tilt.register "html", ECR.embed


# Add alias
Tilt.alias "html", "ecr"
```

### For developer of template engine

This is the process of `Tilt.embed`.

  1. There are `<FilenameExtension>.embed` macro in global space. (`<FilenameExtension>` is your template engine's filename extension. When it is less then 4 character, it should be upper case. Otherwise, when it is more than or equal 4 character,it should be camel-case.)
  2. When `Tilt.embed(filename)` is called, `Tilt` calls `<FilenameExtension>.embed` or registered engine if `filename` has extension. Otherwise, `Tilt` calls default engine.

```crystal
require "tilt"

module FMT
  # Render `filename` by `sprintf`
  def self.embed(filename, io, arg = nil)
    io << sprintf(File.read(filename), arg)
  end
end

# Render with `FMT` template engine
puts Tilt.render "hello.fmt", { "name" => "Tilt" }
```

If you create new template engine supported Tilt, I welcome your [Pull Request](https://github.com/MakeNowJust/tilt/pulls) to add it to supported engine list. (And, I wanna you add specs for this engine.)


## Development

```console
$ crystal spec
```

## Contributing

1. Fork it ( <https://github.com/MakeNowJust/tilt/fork> )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [@MakeNowJust](https://github.com/MakeNowJust) TSUYUSATO Kitsune - creator, maintainer
