module Tilt
  VERSION = "2.0.0"

  # :nodoc:
  INTERNAL = {
    default: "ecr",
    engine: {} of String => String,
  }

  macro embed(filename, io_name, *args)
    {% parts = filename.split("/").last.split(".") %}
    {% if parts.size >= 2 %}
      {% extension = parts.last %}
    {% else %}
      {% extension = INTERNAL[:default] %}
      {% filename = filename + "." + extension %}
    {% end %}
    {% embed = INTERNAL[:engine][extension] ||
         "::#{(extension.size >= 4 ? extension.camelcase : extension.upcase).id}.embed" %}

    {{ embed.id }}({{ filename }}, {{ io_name.id }}, {{ *args }})
  end

  macro render(filename, *args)
    ::String.build do |__tilt_io__|
      ::Tilt.embed({{ filename }}, __tilt_io__, {{ *args }})
    end
  end

  macro file(filename, *args)
    def to_s(__tilt_io__)
      ::Tilt.embed({{ filename }}, __tilt_io__, {{ *args }})
    end
  end

  macro default_engine(engine)
    {% INTERNAL[:default] = engine %}
  end

  macro register(extension, embed_code)
    {% INTERNAL[:engine][extension] = embed_code.stringify %}
  end

  macro alias(extension, original)
    {% embed = INTERNAL[:engine][original] ||
               "::#{original.size >= 4 ? original.camelcase.id : original.upcase.id}.embed" %}
    {% INTERNAL[:engine][extension] = embed %}
  end
end
