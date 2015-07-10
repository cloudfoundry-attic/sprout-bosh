require 'yaml'

bosh_config_path = "#{node['sprout']['home']}/.bosh_config"

bosh_config = if File.exist? bosh_config_path
                YAML::load_file(bosh_config_path)
              else
                {
                  'aliases' => {
                    'target' => {}
                  }
                }
              end

node['bosh']['directors'].each do |director|
  bosh_config['aliases']['target'][director['name']] = director['url']
end

file bosh_config_path do
  content bosh_config.to_yaml
  owner node['sprout']['user']
end
