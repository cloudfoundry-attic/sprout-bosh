homebrew_cask 'atom'

node['atom']['packages'].each do |package|
  execute "install atom #{package} package" do
    command "apm install #{package}"
    user node['sprout']['user']
    not_if "apm list | grep \" #{package}@\""
  end
end
