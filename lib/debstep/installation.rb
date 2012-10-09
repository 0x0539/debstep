module Debstep
  class Installation
    def initialize(workspace, path, &block)
      raise Exception.new('path is a required variable') if path.nil? || path.strip.empty?
      raise Exception.new('install path must be absolute (start with a "/")') unless path[0] == '/'

      @path = "#{workspace}#{path}"
      FileUtils.mkdir_p(@path)

      instance_eval(&block)
    end

    def folder(path, opts={})
      FileUtils.cp_r(path, target(path, opts))
    end

    def template(path, opts={})
      File.open(target(path, opts), 'w') do |file| 
        file.write(ERB.new(File.open(path, 'r').read).result) 
      end
    end

    alias :file :folder
    alias :erb :template

    private

      # gets the install destination given the source path and the options
      def target(path, opts)
        basename = opts[:as] || File.basename(path)
        "#{@path}/#{basename}"
      end

  end
end
