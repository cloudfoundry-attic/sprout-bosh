replay_plugin_config_path = "#{node['sprout']['home']}/.cf/plugins/CmdSetRecords"

[
  ::File.join(node['sprout']['home'], '.cf'),
  ::File.join(node['sprout']['home'], '.cf', 'plugins')
].each do |directory|
  directory directory do
    owner node['sprout']['user']
    recursive true
  end
end

cookbook_file replay_plugin_config_path do
  source "cf_cli/CmdSetRecords"
  user node['sprout']['user']
  mode "0644"
end

execute 'install cf cli Diego-Enabler plugin' do
  command "cf uninstall-plugin Diego-Enabler; cf install-plugin Diego-Enabler -r CF-Community -f"
  user node['sprout']['user']
end

execute 'install cf cli CLI-Recorder plugin' do
  command "cf uninstall-plugin CLI-Recorder; cf install-plugin CLI-Recorder -r CF-Community -f"
  user node['sprout']['user']
end

execute 'install cf cli v3-cli-plugin plugin' do
  command "cf uninstall-plugin v3_beta; cf install-plugin https://github.com/cloudfoundry/v3-cli-plugin/blob/master/bin/OSX_binary?raw=true -f"
  user node['sprout']['user']
end
