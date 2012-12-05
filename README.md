debstep
=======

Ruby gem and DSL ([API?]{http://www.oreillynet.com/onlamp/blog/2007/05/the_is_it_a_dsl_or_an_api_ten.html}) to assist with the scripted creation of Debian packages. The tool makes it easy to use Debian artifacts for your own software in automated systems. Here is an example build script that will create a Debian package called 'my-essentials':

```
require 'debstep'
version = '1.0'

Debstep::Package.new 'my-essentials', :workspace => './build' do
  self.Version = version
  self.Maintainer = 'me@example.com'
  self.Description = 'Contains the software I consider to be a necessity.'
  self.Architecture = 'all'

  self.Depends = %w(vim).join(',')

  self.Section = 'misc'
  self.Priority = 'standard'

  preinst do
    run 'path/to/preinst1.sh'    # adds to preinst
    template './preinst2.sh.erb' # renders with ERB and adds to preinst
  end

  prerm do
    run 'path/to/prerm.sh'       # adds to prerm
  end

  postrm do
    run 'path/to/postrm1.sh'     # adds to postrm
    run 'path/to/postrm2.sh'
  end

  postinst do
    run 'path/to/postinst1.sh'   # adds to postinst
  end

  install '/usr/bin/local' do
    folder './to/install/bin'    # installs all files in folder to /usr/bin/local
    file   './other.bin'         # installs file to /usr/bin/local/other.bin
  end

  install '/etc/config.conf' do
    template './config.conf.erb' # renders with ERB and installs to /etc/config.conf
  end
end
```

Running the script will generate a .deb file, which you can install directly with ```dpkg -i <debfile>.deb``` (not recommended) or add to a Debian repository using ```reprepro``` (recommended). You do not get automatic dependency resolution unless you use the Debian repository approach.

In my environments, I typically use my CI server as my package server and use apt-get to download packages from it. Once you are confident that your Debian repository is configured correctly, you can add an entry to /etc/apt/sources.list or /etc/apt/sources.list.d and then ```sudo apt-get update && sudo apt-get install <your-package>```.


