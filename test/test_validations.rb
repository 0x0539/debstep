require 'test/unit'
require 'debstep'

class TestValidations < Test::Unit::TestCase

  def test_has_valid_base
    Debstep::Package.new 'testpkg' do
      self.Version = '0.0.0'
      self.Maintainer = 'me'
      self.Description = 'oyea'
      self.Architecture = 'all'
    end
  end

  def teardown
    FileUtils.rmtree('testpkg')
    FileUtils.rm_f('testpkg.deb')
  end

  def test_required_package
    assert_raise Debstep::Exception do
      Debstep::Package.new '' do
        self.Version = '0.0.0'
        self.Maintainer = 'me'
        self.Description = 'oyea'
        self.Architecture = 'all'
      end
    end
  end

  def test_required_version
    assert_raise Debstep::Exception do
      Debstep::Package.new 'testpkg' do
        self.Maintainer = 'me'
        self.Description = 'oyea'
        self.Architecture = 'all'
      end
    end
  end

  def test_required_maintainer
    assert_raise Debstep::Exception do
      Debstep::Package.new 'testpkg' do
        self.Version = '0.0.0'
        self.Description = 'oyea'
        self.Architecture = 'all'
      end
    end
  end

  def test_required_description
    assert_raise Debstep::Exception do
      Debstep::Package.new 'testpkg' do
        self.Version = '0.0.0'
        self.Maintainer = 'me'
        self.Architecture = 'all'
      end
    end
  end

  def test_required_architecture
    assert_raise Debstep::Exception do
      Debstep::Package.new 'testpkg' do
        self.Version = '0.0.0'
        self.Maintainer = 'me'
        self.Description = 'oyea'
      end
    end
  end

end
