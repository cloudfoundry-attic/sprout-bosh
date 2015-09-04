include_recipe 'sprout-chruby'

sprout_base_bash_it_custom_plugin 'bash_it/custom/fast_bosh.bash'

def install_bosh_cli(ruby)
  command = Mixlib::ShellOut.new("chruby-exec #{ruby} -- gem list bosh_cli | grep bosh_cli", user: node['sprout']['user'])
  command.run_command
  return if command.exitstatus == 0

  execute "install bundler for #{ruby}" do
    command "bash -l -c 'chruby-exec #{ruby} -- gem install bundler'"
    user node['sprout']['user'] unless ruby == 'system'
  end

  execute "install bosh cli for #{ruby}" do
    command "chruby-exec #{ruby} -- gem install bosh_cli"
    user node['sprout']['user'] unless ruby == 'system'
  end
end

rubies = node['sprout']['chruby']['rubies']

rubies.each do |ruby_vm, ruby_versions|
  ruby_versions.each do |ruby_version|
    ruby = "#{ruby_vm}-#{ruby_version}"
    install_bosh_cli(ruby)
  end
end
