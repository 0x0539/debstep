debstep
=======

Ruby gem and DSL ([API?](http://www.oreillynet.com/onlamp/blog/2007/05/the_is_it_a_dsl_or_an_api_ten.html)) to assist with the scripted creation of Debian packages. The tool makes it easy to use Debian artifacts for your own software in automated systems. Here is an example build script that will create a Debian package called 'my-essentials':

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

Running the script will generate a .deb file, which you can install directly with ```dpkg -i <debfile>.deb``` (not recommended) or add to a Debian repository using ```reprepro``` (recommended). You do not get automatic dependency resolution unless you use the Debian repository approach and some kind of dpkg front-end like aptitude.

I use my CI server to host a Debian repository. Whenever a commit is made, the CI server builds new packages using debstep and installs them locally using reprepro. Clients use apt-get to download packages from the server, assuming they have configured /etc/apt/sources.list (or sources.list.d) correctly.

Together with [awsome](https://github.com/0x0539/awsome.git) and [Jenkins](http://jenkins-ci.org/), you can have automated package building and deployments up and running in AWS in no time.

