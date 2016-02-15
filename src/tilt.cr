module TILT
  VERSION = "1.0.0"

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
    {% embed = INTERNAL[:engine][extension] || "embed_#{extension.id}" %}

    ::{{ embed.id }}({{ filename }}, {{ io_name.is_a?(StringLiteral) ? io_name : io_name.stringify }}, {{ *args }})
  end

  macro render(filename, *args)
    ::String.build do |__tilt_io__|
      ::TILT.embed({{ filename }}, __tilt_io__, {{ *args }})
    end
  end

  macro file(filename)
    def to_s(__tilt_io__)
      ::TILT.embed {{ filename }}, __tilt_io__
    end
  end

  macro default_engine(engine)
    {% INTERNAL[:default] = engine %}
  end

  macro register(extension, embed)
    {% INTERNAL[:engine][extension] = embed.stringify %}
  end
end
