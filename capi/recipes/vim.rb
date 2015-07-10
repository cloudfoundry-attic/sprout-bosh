cookbook_file "#{node['sprout']['home']}/.vimrc.local" do
  source "vim/vimrc.local"
  user node['sprout']['user']
  mode "0644"
end
