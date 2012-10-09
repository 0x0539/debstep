require 'erb'

module Debstep
  class ScriptKeeper
    attr_reader :script

    def initialize(init="#!/usr/bin/env bash", &block)
      @script = init + "\n"
      instance_eval(&block)
    end

    def file(path)
      @script += File.open(path, 'r').read.strip + "\n"
    end

    def template(path)
      @script += ERB.new(File.open(path, 'r').read.strip).result + "\n"
    end
  end
end
