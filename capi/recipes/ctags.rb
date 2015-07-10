execute "tap kopischke/ctags" do
  command "brew tap kopischke/ctags"
  not_if "brew tap | grep 'kopischke/ctags' > /dev/null 2>&1"
  user node['sprout']['user']
end

execute "brew install ctags-fishman --HEAD" do
  command "brew install ctags-fishman --HEAD"
  user node['sprout']['user']
end
