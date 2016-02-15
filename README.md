# tilt

TILT Is Loader of Template. It is generalized template engine interface.

[![Build Status](https://travis-ci.org/MakeNowJust/tilt.svg?branch=master)](https://travis-ci.org/MakeNowJust/tilt)


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

puts TILT.render "hello.ecr"      # render as "ecr"
puts TILT.render "hello.mustache" # render as "mustache" (using crustache)
puts TILT.render "hello.slang"    # render as "slang"


# Set the default template engine

TILT.default_engine "ecr"

puts TILT.render "hello" # render as "ecr" although without extension


# Other APIs

# It is like `TILT.render`, but it requires IO object then renders to this.
puts String.build { |io| TILT.embed "hello", io }


# Load specified template file, and define `#to_s` method to render this file.
class HelloView
  def initialize(@name); end

  getter name

  TILT.file "hello"
end

puts HelloView.new("MakeNowJust").to_s


# Passing additional arguments to the template if the engine supported
puts TILT.render("hello.mustache", { "name" => "MakeNowJust" })


# Add your template engine
TILT.register "html", embed_ecr
```

### For developer of template engine

  1. You could define `embed_<extension>` macro in global space. (`<extension>` is your template engine's filename extension.)
  2. `embed_<extension>` requires two arguments at least, the first argument is `filename`, and the second argument is IO object's name.
  3. Then, `TILT` detects your template engine, and using it when `filename`'s extension is `<extension>`.

Note: This spec is unstable, it is probably changed.

```crystal
require "tilt"

# Render `filename` by `String#format`
# It is TILT compatible template engine.
macro embed_fmt(filename, io, map = nil)
  {{ io.id }} << sprintf({{ `cat #{filename}`.stringify }}, {{ map }})
end

# Render with `fmt` template engine
puts TILT.render "hello.fmt", { "name" => "MakeNowJust" }
```

If you create new template engine supporting TILT, I welcome your [Pull Request](https://github.com/MakeNowJust/tilt/pulls) to add it to supported engine list.


## Development

```console
$ crystal spec
```

## Contributing

1. Fork it ( <https://github.com/MakeNowJust/tilt/fork> )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [@MakeNowJust](https://github.com/MakeNowJust) TSUYUSATO Kitsune - creator, maintainer
