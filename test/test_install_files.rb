require 'test/unit'
require 'debstep'

class TestInstallFiles < Test::Unit::TestCase
  def setup
    Debstep::Package.new 'testpkg' do
      self.Version = '0.0.0'
      self.Maintainer = 'me'
      self.Description = 'oyea'
      self.Architecture = 'all'
      install '/filetest' do
        file 'test/test_install_files.rb'
      end
      install '/foldertest' do
        file 'test'
      end
      install '/renametest' do
        file 'test/test_install_files.rb', :as => 'testikus'
      end
      install '/templatetest' do
        template 'test/template.erb', :as => 'templated'
        template 'test/template.erb'
      end
    end
  end

  def teardown
    FileUtils.rmtree('testpkg')
    FileUtils.rm_f('testpkg.deb')
  end

  def test_file_is_correct
    FileUtils.identical?('test/test_install_files.rb', 'testpkg/filetest/test_install_files.rb')
  end

  def test_folder_is_correct
    FileUtils.identical?('test/test_install_files.rb', 'testpkg/foldertest/test/test_install_files.rb')
    FileUtils.identical?('test/test_install_files.rb', 'testpkg/foldertest/test/test_install_files.rb')
  end

  def test_renaming
    FileUtils.identical?('test/test_install_files.rb', 'testpkg/renametest/testikus')
  end

  def test_templating
    assert_equal('42 is the answer to 6*8.', File.open('testpkg/templatetest/templated', 'r').read.strip)
  end
  
  def test_multiple_things
    FileUtils.identical?('testpkg/templatetest/templated', 'testpkg/templatetest/template.erb')
  end
end
