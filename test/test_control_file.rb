require 'test/unit'
require 'debstep'

class TestControlFile < Test::Unit::TestCase
  def setup
    Debstep::Package.new 'testpkg' do
      self.Version = '0.0.0'
      self.Maintainer = 'me'
      self.Description = 'oyea'
      self.Architecture = 'all'
      self.depends 'nginx', '0.0.0'
      self.depends 'jea'
      self.depends 'awesomeo', '>= 0.1.0'
    end
  end

  def teardown
    FileUtils.rmtree('testpkg')
    FileUtils.rm_f('testpkg.deb')
  end

  def test_has_version
    assert_not_nil File.open("testpkg/DEBIAN/control").find do |line|
      line == "Version: 0.0.0"
    end
  end

  def test_has_maintainer
    assert_not_nil File.open("testpkg/DEBIAN/control").find do |line|
      line == "Maintainer: me"
    end
  end

  def test_has_description
    assert_not_nil File.open("testpkg/DEBIAN/control").find do |line|
      line == "Description: oyea"
    end
  end

  def test_has_architecture
    assert_not_nil File.open("testpkg/DEBIAN/control").find do |line|
      line == "Architecture: all"
    end
  end

  def test_has_depends
    assert_not_nil File.open("testpkg/DEBIAN/control").find do |line|
      line == "Depends: nginx (0.0.0), jea, awesomeo (>= 0.1.0)"
    end
  end
end
