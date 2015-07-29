include_recipe 'sprout-base::workspace_directory'

node['sprout-bosh']['repos'].each do |repo|
  git "#{node['sprout']['home']}/#{node["workspace_directory"]}/#{repo['name']}" do
    repository repo['url'] || "git@github.com:cloudfoundry/#{repo['name']}.git"
    revision repo['branch']
    user node['sprout']['user']
    action :checkout
  end
end
