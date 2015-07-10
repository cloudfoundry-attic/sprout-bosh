package 'coreutils'

git "#{node['sprout']['home']}/.fzf" do
  repository "https://github.com/junegunn/fzf.git"
  user node['sprout']['user']
  action :checkout
  depth 1
end

tac_path = '/usr/local/bin/tac'
link tac_path do
  to ::File.expand_path('/usr/local/bin/gtac', tac_path)
  owner node['sprout']['user']
  not_if { ::File.symlink?(tac_path) }
end

system('yes | bash ~/.fzf/install')
