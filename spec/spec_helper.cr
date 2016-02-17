require "spec"
require "../src/tilt"

require "ecr/macros"
require "crustache"
require "slang"

module FMT
  # Render `filename` by `sprintf`
  def self.embed(filename, io, arg = nil)
    io << sprintf(File.read(filename), arg)
  end
end
