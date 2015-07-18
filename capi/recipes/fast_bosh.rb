require 'etc'
require 'bundler'

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

execute "install bundler" do
  command "bash -l -c 'chruby-exec 2.1.6 -- gem install bundler'"
  user node['sprout']['user']
end

ruby_block "install bosh cli" do
  block do
    Bundler.with_clean_env do
      Dir.chdir(fast_bosh_path) do
        Process.fork do
          Process.uid = Etc.getpwnam(node['sprout']['user']).uid

          `bash -l -c 'GEM_PATH= BUNDLE_GEMFILE=#{fast_bosh_path}/Gemfile chruby-exec 2.1.6 -- bundle install'`
        end
      end
    end
  end
end
