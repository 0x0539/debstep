require 'erb'

module Debstep
  class ScriptKeeper
    attr_reader :script

    def initialize(init="#!/usr/bin/env bash", &block)
      @script = init + "\n"
      instance_eval(&block) if block_given?
    end

    def file(path)
      append(File.open(path, 'r').read.strip)
    end

    def raw(value)
      append(value)
    end

    def template(path)
      append(ERB.new(File.open(path, 'r').read.strip).result)
    end

    def append(value)
      @script += value + "\n"
    end

    alias :run :file
  end
end
