package 'vim'
homebrew_cask 'macvim'

vimfiles = ::File.join(node['sprout']['home'], node['workspace_directory'], 'vimfiles')
git vimfiles do
  repository 'http://github.com/luan/vimfiles.git'
  revision 'master'
  user node['sprout']['user']
  enable_submodules true
  action :checkout
end

dotvim = ::File.join(node['sprout']['home'], '.vim')

link dotvim do
  to vimfiles
  owner node['sprout']['user']
end

execute './install --non-interactive' do
  cwd dotvim
  user node['sprout']['user']
end
