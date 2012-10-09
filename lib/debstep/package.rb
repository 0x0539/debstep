require 'fileutils'

module Debstep
  class Package

    @@required_control_fields = %w( Package Version Maintainer Description Architecture )
    @@optional_control_fields = %w( Depends )

    @@control_fields = @@required_control_fields + @@optional_control_fields
    @@control_fields.each do |a|
      attr_accessor a.to_sym
    end

    def initialize(name, opts={}, &block)
      raise Exception.new('package name must be provided') if name.nil? || name.strip.empty?

      self.Package = name

      workspace_root = opts[:workspace] || '.'

      @workspace = "#{workspace_root}/#{self.Package}"
      FileUtils.rm_r(@workspace) if File.exists?(@workspace)
      FileUtils.mkdir_p(@workspace)

      instance_eval(&block)

      save("#{@workspace}.deb")
    end

    def install(path, &block)
      Installation.new(@workspace, path, &block) 
    end

    def depends(package, version=nil)
      @depends ||= []
      @depends << case
      when package && version then "#{package} (#{version})"
      when package then package
      else raise Exception.new('must specify a package')
      end
    end

    def postinst(*args, &block)
      @postinst = ScriptKeeper.new(*args, &block).script
    end

    def preinst(*args, &block)
      @preinst = ScriptKeeper.new(*args, &block).script
    end

    def postrm(*args, &block)
      @postrm = ScriptKeeper.new(*args, &block).script
    end

    def prerm(*args, &block)
      @prerm = ScriptKeeper.new(*args, &block).script
    end

    def control_field_value(field)
      send(field.to_sym)
    end

    def control_field_specified?(field)
      value = control_field_value(field)
      !value.nil? && !value.strip.empty?
    end

    def save(path)
      @@required_control_fields.each do |field|
        raise Exception.new("#{field} is required") unless control_field_specified?(field)
      end

      FileUtils.mkdir("#{@workspace}/DEBIAN")

      self.Depends = case
      when self.Depends && @depends then "#{self.Depends}, #{@depends.join(', ')}"
      when self.Depends then self.Depends
      when @depends then @depends.join(', ')
      end

      File.open("#{@workspace}/DEBIAN/control", 'w') do |file|
        @@control_fields.select do |field|
          control_field_specified?(field)
        end.each do |field|
          file.write("#{field}: #{control_field_value(field)}\n")
        end
      end

      File.open("#{@workspace}/DEBIAN/preinst", 'w') do |file|
        file.write(@preinst)
      end if @preinst

      File.open("#{@workspace}/DEBIAN/postinst", 'w') do |file|
        file.write(@postinst)
      end if @postinst

      File.open("#{@workspace}/DEBIAN/prerm", 'w') do |file|
        file.write(@prerm)
      end if @prerm

      File.open("#{@workspace}/DEBIAN/postrm", 'w') do |file|
        file.write(@postrm)
      end if @postrm

      `dpkg-deb --build #{@workspace}`
    end
  end
end
