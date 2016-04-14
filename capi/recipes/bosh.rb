include_recipe 'sprout-chruby'

def chruby_gem(gem)
  rubies = node['sprout']['chruby']['rubies']
  rubies.each do |ruby_vm, ruby_versions|
    ruby_versions.each do |ruby_version|
      ruby = "#{ruby_vm}-#{ruby_version}"
      gem_for_ruby(gem, ruby)
    end
  end
end

def gem_for_ruby(gem, ruby)
  execute "install #{gem} for #{ruby}" do
    command "bash -l -c 'chruby-exec #{ruby} -- gem install #{gem}'"
    user node['sprout']['user'] unless ruby == 'system'
    environment 'GEM_PATH' => ''
  end
end

chruby_gem('bundler')
chruby_gem('bosh_cli')
