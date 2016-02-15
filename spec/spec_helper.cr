require "spec"
require "../src/tilt"

require "ecr/macros"
require "crustache"
require "slang"

macro embed_fmt(filename, io, model = nil)
  {{ io.id }} << sprintf({{ `cat #{filename}`.stringify }}, {{ model }})
end
