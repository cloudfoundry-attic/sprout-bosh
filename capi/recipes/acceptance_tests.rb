integration_config_path = "#{node['sprout']['home']}/#{node['workspace_directory']}/cf-release/src/github.com/cloudfoundry/cf-acceptance-tests/integration_config.json"

cookbook_file integration_config_path do
  source "acceptance_tests/integration_config.json"
  user node['sprout']['user']
  mode "0644"
end
