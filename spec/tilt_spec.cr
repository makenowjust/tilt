require "./spec_helper"

{% for ext in %w(ecr mustache slang fmt).map(&.id) %}
  record File{{ ext.camelcase }}, name do
    Tilt.file("spec/fixture/{{ext}}/hello.{{ext}}")
  end
{% end %}

{% for ext in %w(mustache fmt).map(&.id) %}
  class FileModel{{ ext.camelcase }} < Hash(String, String?)
    def initialize(@name); super() end

    def has_key?(key)
      key == "name"
    end

    def [](key)
      key == "name" ? @name : nil
    end

    Tilt.file("spec/fixture/{{ext}}/model.{{ext}}", self)
  end
{% end %}

describe Tilt do
  describe "embed" do
    {% for ext in %w(ecr mustache slang fmt).map(&.id) %}
      it "render the {{ext}} template with IO object" do
        name = "Tilt"
        String.build do |io|
          Tilt.embed("spec/fixture/{{ext}}/hello.{{ext}}", io)
        end.should eq "Hello, Tilt!\n"
      end
      
      it "render the {{ext}} template with IO variable name" do
        name = "Tilt"
        String.build do |io|
          Tilt.embed("spec/fixture/{{ext}}/hello.{{ext}}", "io")
        end.should eq "Hello, Tilt!\n"
      end
    {% end %}

    {% for ext in %w(mustache fmt).map(&.id) %}
      it "render the {{ext}} template with model data" do
        String.build do |io|
          Tilt.embed("spec/fixture/{{ext}}/model.{{ext}}", io, { "name" => "Tilt" })
        end.should eq "Hello, Tilt!\n"
      end
    {% end %}

    it "(default template engine is ECR)" do
      name = "Tilt"
      String.build do |io|
        Tilt.embed("#{__DIR__}/fixture/ecr/hello", io)
      end.should eq "Hello, Tilt!\n"
    end
  end

  describe "render" do
    {% for ext in %w(ecr mustache slang fmt).map(&.id) %}
      it "render the {{ext}} template" do
        name = "Tilt"
        Tilt.render("spec/fixture/{{ext}}/hello.{{ext}}").should eq "Hello, Tilt!\n"
      end
    {% end %}

    {% for ext in %w(mustache fmt).map(&.id) %}
      it "render the {{ext}} template with model data" do
        Tilt.render("spec/fixture/{{ext}}/model.{{ext}}", { "name" => "Tilt" }).should eq "Hello, Tilt!\n"
      end
    {% end %}
  end

  describe "file" do
    {% for ext in %w(ecr mustache slang fmt).map(&.id) %}
      it "render the {{ext}} template" do
        File{{ ext.camelcase }}.new("Tilt").to_s.should eq "Hello, Tilt!\n"
      end
    {% end %}

    {% for ext in %w(mustache fmt).map(&.id) %}
      it "render the {{ext}} template" do
        FileModel{{ ext.camelcase }}.new("Tilt").to_s.should eq "Hello, Tilt!\n"
      end
    {% end %}
  end

  describe "default_engine" do
    {% for ext in %w(ecr mustache slang fmt).map(&.id) %}
      it "render the {{ext}} template" do
        Tilt.default_engine {{ ext.stringify }}
        name = "Tilt"
        Tilt.render("spec/fixture/{{ext}}/hello").should eq "Hello, Tilt!\n"
      end
    {% end %}
  end

  describe "register" do
    it "add template engine"do
      Tilt.register "register", FMT.embed
      Tilt.render("spec/fixture/hello.register", { "name" => "Tilt" }).should eq "Hello, Tilt!\n"
    end
  end

  describe "alias" do
    it "alias template engine"do
      Tilt.alias "alias", "fmt"
      Tilt.render("spec/fixture/hello.alias", { "name" => "Tilt" }).should eq "Hello, Tilt!\n"
    end
  end
end
