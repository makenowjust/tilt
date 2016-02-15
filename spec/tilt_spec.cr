require "./spec_helper"

{% for ext in %w(ecr mustache slang fmt).map(&.id) %}
  record File{{ ext.camelcase }}, name do
    TILT.file("spec/template/{{ext}}/hello.{{ext}}")
  end
{% end %}

describe TILT do
  describe "embed" do
    {% for ext in %w(ecr mustache slang fmt).map(&.id) %}
      it "render the {{ext}} template with IO object" do
        name = "TILT"
        String.build do |io|
          TILT.embed("spec/template/{{ext}}/hello.{{ext}}", io)
        end.should eq "Hello, TILT!\n"
      end
      
      it "render the {{ext}} template with IO variable name" do
        name = "TILT"
        String.build do |io|
          TILT.embed("spec/template/{{ext}}/hello.{{ext}}", "io")
        end.should eq "Hello, TILT!\n"
      end
    {% end %}

    {% for ext in %w(mustache fmt).map(&.id) %}
      it "render the {{ext}} template with model data" do
        String.build do |io|
          TILT.embed("spec/template/{{ext}}/model.{{ext}}", io, { "name" => "TILT" })
        end.should eq "Hello, TILT!\n"
      end
    {% end %}

    it "(default template engine is ECR)" do
      name = "TILT"
      String.build do |io|
        TILT.embed("#{__DIR__}/template/ecr/hello", io)
      end.should eq "Hello, TILT!\n"
    end
  end

  describe "render" do
    {% for ext in %w(ecr mustache slang fmt).map(&.id) %}
      it "render the {{ext}} template" do
        name = "TILT"
        TILT.render("spec/template/{{ext}}/hello.{{ext}}").should eq "Hello, TILT!\n"
      end
    {% end %}

    {% for ext in %w(mustache fmt).map(&.id) %}
      it "render the {{ext}} template with model data" do
        TILT.render("spec/template/{{ext}}/model.{{ext}}", { "name" => "TILT" }).should eq "Hello, TILT!\n"
      end
    {% end %}
  end

  describe "file" do
    {% for ext in %w(ecr mustache slang fmt).map(&.id) %}
      it "render the {{ext}} template" do
        File{{ ext.camelcase }}.new("TILT").to_s.should eq "Hello, TILT!\n"
      end
    {% end %}
  end

  describe "default_engine" do
    {% for ext in %w(ecr mustache slang fmt).map(&.id) %}
      it "render the {{ext}} template" do
        TILT.default_engine {{ ext.stringify }}
        name = "TILT"
        TILT.render("spec/template/{{ext}}/hello").should eq "Hello, TILT!\n"
      end
    {% end %}
  end

  describe "register" do
    it "add template engine"do
      TILT.register "tmpl", embed_fmt
      TILT.render("spec/template/hello.tmpl", { "name" => "TILT" }).should eq "Hello, TILT!\n"
    end
  end
end
