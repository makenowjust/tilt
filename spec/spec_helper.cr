require "spec"
require "../src/tilt"

require "ecr/macros"
require "crustache"
require "slang"

macro embed_fmt(filename, io, model = nil)
  {{ io.id }} << sprintf File.read({{ filename }}), {{ model }}
end
