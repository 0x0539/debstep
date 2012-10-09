require 'debstep'

Debstep::Package.new 'awesome' do
  self.Version = '0.0.1'
  self.Maintainer = 'me'
  self.Description = 'blahblah'
  self.Architecture = 'all'
  install '/home/foodocs' do
    file 'sites/foodocs.com'
  end
end
