include_recipe 'cf-bosh::repos'

directory "#{node['sprout']['home']}/Checkman" do
  recursive true
  action :delete
end

link "#{node['sprout']['home']}/Checkman" do
  to "#{node['sprout']['home']}/workspace/bosh-checkman"
  owner node['sprout']['user']
end
