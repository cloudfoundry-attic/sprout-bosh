include_recipe 'sprout-chruby'

sprout_base_bash_it_custom_plugin 'bash_it/custom/fast_bosh.bash'

fast_bosh_path = "#{node['sprout']['home']}/#{node['workspace_directory']}/fast-bosh"
directory fast_bosh_path do
  recursive true
  owner node['sprout']['user']
end

cookbook_file "#{fast_bosh_path}/Gemfile" do
  source "fast_bosh/Gemfile"
  user node['sprout']['user']
  mode "0644"
end

cookbook_file "#{fast_bosh_path}/.ruby-version" do
  source "fast_bosh/.ruby-version"
  user node['sprout']['user']
  mode "0644"
end

execute "install bosh cli" do
  command "BUNDLE_GEMFILE=#{File.join fast_bosh_path, 'Gemfile'} chruby-exec system -- bundle install"
  cwd fast_bosh_path
  user node['sprout']['user']
end
