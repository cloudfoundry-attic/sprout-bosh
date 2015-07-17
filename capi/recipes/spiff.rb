include_recipe 'sprout-osx-apps::go'

execute 'install spiff' do
  command 'go get -v -u github.com/cloudfoundry-incubator/spiff'
  environment(
    'GOPATH' 	 => ENV['GOPATH'] || File.join(node['sprout']['home'], 'go'),
    'PYTHONPATH' => '/usr/local/lib/python2.7/site-packages'
  )
  user node['sprout']['user']
end
